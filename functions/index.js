const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
//const { Logging } = require('@google-cloud/logging');
//const logging = new Logging({
//  projectId: process.env.GCLOUD_PROJECT,
//});
const stripe = require('stripe')(functions.config().stripe.secret, {
  apiVersion: '2020-03-02',
});
const nodemailer = require('nodemailer');
const dayjs = require('dayjs');

/**
 * When a user is created, create a Stripe customer object for them.
 *
 * @see https://stripe.com/docs/payments/save-and-reuse#web-create-customer
 */
exports.createStripeCustomer = functions.auth.user().onCreate(async (user) => {
  const customer = await stripe.customers.create({ email: user.email });
  const intent = await stripe.setupIntents.create({
    customer: customer.id,
  });
  await admin.firestore().collection('customers').doc(user.uid).set({
    customer_id: customer.id,
    setup_secret: intent.client_secret,
  }, { merge: true });

  return;
});

/**
 * When a user is created, create a Stripe customer object for them.
 *
 * @see https://stripe.com/docs/payments/save-and-reuse#web-create-customer
 */
exports.deleteStripeCustomer = functions.auth.user().onDelete(async (user) => {

  const customerData = await admin.firestore().doc(`customers/${user.uid}`).get();
  const customerId = customerData.data().customer_id;

  await stripe.customers.del(customerId);

  await admin.firestore().collection('customers').doc(user.uid).delete();
  return;
});
/**
 * When 3D Secure is performed, we need to reconfirm the payment
 * after authentication has been performed.
 *
 * @see https://stripe.com/docs/payments/accept-a-payment-synchronously#web-confirm-payment
 */
exports.addCustomerDetails = functions.firestore
  .document('customers/{userId}')
  .onUpdate(async (change, context) => {
    const customerInfo = change.after.data();

    const body = {
      name: customerInfo.name,
      address: {
        line1: customerInfo.address.line1,
        city: customerInfo.address.city,
        country: customerInfo.address.country,
        postal_code: customerInfo.address.postal_code,
        state: customerInfo.address.state
      },
      shipping: {
        address: {
          line1: customerInfo.address.line1,
          city: customerInfo.address.city,
          country: customerInfo.address.country,
          postal_code: customerInfo.address.postal_code,
          state: customerInfo.address.state
        },
        name: customerInfo.name,

      }
    }

    const customer = await stripe.customers.update(
      customerInfo.customer_id,
      body,
    );

    change.after.ref.set(customer, { merge: true });

  });

/**
 * When adding the payment method ID on the client,
 * this function is triggered to retrieve the payment method details.
 */
exports.addPaymentMethodDetails = functions.firestore
  .document('/customers/{userId}/payment_methods/{pushId}')
  .onCreate(async (snap, context) => {

    try {
      const paymentMethodId = snap.id;
      const customerId = (await snap.ref.parent.parent.get()).data().customer_id;

      console.log(paymentMethodId);
      console.log(customerId);

      // const paymentMethod = await stripe.paymentMethods.retrieve(
      //   paymentMethodId
      // );

      // Adds payment method to customer
      const customerPaymentMethod = await stripe.paymentMethods.attach(
        paymentMethodId,
        { customer: customerId }
      );

      await stripe.customers.update(
        customerId,
        { invoice_settings: { default_payment_method: paymentMethodId } }
      );

      await snap.ref.set(customerPaymentMethod);

      // Create a new SetupIntent so the customer can add a new method next time.
      // const intent = await stripe.setupIntents.create({
      //   customer: paymentMethod.customer,
      // });

      // await snap.ref.parent.parent.set(
      //   {
      //     setup_secret: intent.client_secret,
      //   },
      //   { merge: true }
      // );
      return;
    } catch (error) {
      console.log(error);
      // await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
      // await reportError(error, { user: context.params.userId });
      console.log("Error Occured");
    }
  });


/**
 * When a payment document is written on the client,
 * this function is triggered to create the payment in Stripe.
 *
 * @see https://stripe.com/docs/payments/save-and-reuse#web-create-payment-intent-off-session
 */

// [START chargecustomer]

exports.createStripePayment = functions.firestore
  .document('customers/{userId}/payments/{pushId}')
  .onCreate(async (snap, context) => {
    const { amount, currency, payment_method } = snap.data();
    const applePay = snap.data().apple_pay;
    try {
      console.log(payment_method);
      // Look up the Stripe customer id.
      const customer = (await snap.ref.parent.parent.get()).data().customer_id;
      const customerEmail = (await snap.ref.parent.parent.get()).data().email;
      const customerAddress = (await snap.ref.parent.parent.get()).data().address;
      const customerName = (await snap.ref.parent.parent.get()).data().name;
      // Create a charge using the pushId as the idempotency key
      // to protect against double charges.
      const idempotencyKey = context.params.pushId;
      var body;

      if (applePay) {
        body = {
          amount,
          currency,
          customer,
          payment_method,
          metadata: {
            integration_check: "accept_a_payment"
          },
          setup_future_usage: 'off_session',
        }
      } else {
        body = {
          amount,
          currency,
          customer,
          payment_method,
          confirm: true,
          confirmation_method: 'automatic',
          setup_future_usage: 'off_session',

        }
      }


      const payment = await stripe.paymentIntents.create(
        body,
        { idempotencyKey }
      );
      // If the result is successful, write it back to the database.
      await snap.ref.set(payment);

      var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'contact@thedoggobox.com',
          pass: 'turtletown18'
        }
      });

      var mailOptions = {
        from: '"DoggoBox" <contact@thedoggobox.com>',
        to: customerEmail,
        subject: 'Order #58713 Has Been Received!',
        text: 'Thank you for ordering your DoggoBox, we are working to fulfill your order as soon as possible\n\nBe prepared to spoil your doggo with the best toys and treats in the business\n\nOrder Summary\n\n(1) $1 DoggoBox: $1.00\n\n--------------------\n\nSubtotal:      $1.00\nTaxes:         $0.00\nShipping:      $0.00\n--------------------\nTotal:         $1.00\n\nJordan\nCofounder, Doggo Brand',
        amp: `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html data-editor-version="2" class="sg-campaigns" xmlns="http://www.w3.org/1999/xhtml"><head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
      <!--[if !mso]><!-->
      <meta http-equiv="X-UA-Compatible" content="IE=Edge">
      <!--<![endif]-->
      <!--[if (gte mso 9)|(IE)]>
      <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
      </xml>
      <![endif]-->
      <!--[if (gte mso 9)|(IE)]>
  <style type="text/css">
    body {width: 600px;margin: 0 auto;}
    table {border-collapse: collapse;}
    table, td {mso-table-lspace: 0pt;mso-table-rspace: 0pt;}
    img {-ms-interpolation-mode: bicubic;}
  </style>
<![endif]-->
      <style type="text/css">
    body, p, div {
      font-family: inherit;
      font-size: 14px;
    }
    body {
      color: #000000;
    }
    body a {
      color: #1188E6;
      text-decoration: none;
    }
    p { margin: 0; padding: 0; }
    table.wrapper {
      width:100% !important;
      table-layout: fixed;
      -webkit-font-smoothing: antialiased;
      -webkit-text-size-adjust: 100%;
      -moz-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }
    img.max-width {
      max-width: 100% !important;
    }
    .column.of-2 {
      width: 50%;
    }
    .column.of-3 {
      width: 33.333%;
    }
    .column.of-4 {
      width: 25%;
    }
    @media screen and (max-width:480px) {
      .preheader .rightColumnContent,
      .footer .rightColumnContent {
        text-align: left !important;
      }
      .preheader .rightColumnContent div,
      .preheader .rightColumnContent span,
      .footer .rightColumnContent div,
      .footer .rightColumnContent span {
        text-align: left !important;
      }
      .preheader .rightColumnContent,
      .preheader .leftColumnContent {
        font-size: 80% !important;
        padding: 5px 0;
      }
      table.wrapper-mobile {
        width: 100% !important;
        table-layout: fixed;
      }
      img.max-width {
        height: auto !important;
        max-width: 100% !important;
      }
      a.bulletproof-button {
        display: block !important;
        width: auto !important;
        font-size: 80%;
        padding-left: 0 !important;
        padding-right: 0 !important;
      }
      .columns {
        width: 100% !important;
      }
      .column {
        display: block !important;
        width: 100% !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
        margin-left: 0 !important;
        margin-right: 0 !important;
      }
    }
  </style>
      <!--user entered Head Start--><link href="https://fonts.googleapis.com/css?family=Viga&display=swap" rel="stylesheet"><style>
    body {font-family: 'Viga', sans-serif;}
</style><!--End Head user entered-->
    </head>
    <body>
      <center class="wrapper" data-link-color="#1188E6" data-body-style="font-size:14px; font-family:inherit; color:#000000; background-color:#f0f0f0;">
        <div class="webkit">
          <table cellpadding="0" cellspacing="0" border="0" width="100%" class="wrapper" bgcolor="#f0f0f0">
            <tbody><tr>
              <td valign="top" bgcolor="#f0f0f0" width="100%">
                <table width="100%" role="content-container" class="outer" align="center" cellpadding="0" cellspacing="0" border="0">
                  <tbody><tr>
                    <td width="100%">
                      <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tbody><tr>
                          <td>
                            <!--[if mso]>
    <center>
    <table><tr><td width="600">
  <![endif]-->
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="width:100%; max-width:600px;" align="center">
                                      <tbody><tr>
                                        <td role="modules-container" style="padding:0px 0px 0px 0px; color:#000000; text-align:left;" bgcolor="#ffffff" width="100%" align="left"><table class="module preheader preheader-hide" role="module" data-type="preheader" border="0" cellpadding="0" cellspacing="0" width="100%" style="display: none !important; mso-hide: all; visibility: hidden; opacity: 0; color: transparent; height: 0; width: 0;">
    <tbody><tr>
      <td role="module-content">
        <p></p>
      </td>
    </tr>
  </tbody></table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:30px 20px 40px 30px;" bgcolor="#77dedb">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top">
          <table class="column" width="550" style="width:550px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="wrapper" role="module" data-type="image" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="b422590c-5d79-4675-8370-a10c2c76af02">
    <tbody>
      <tr>
        <td style="font-size:6px; line-height:10px; padding:0px 0px 0px 0px;" valign="top" align="left">
          <img class="max-width" border="0" style="display:block; color:#000000; text-decoration:none; font-family:Helvetica, arial, sans-serif; font-size:16px;" width="150.75" alt="" data-proportionally-constrained="true" data-responsive="false" src="https://firebasestorage.googleapis.com/v0/b/doggobox-clickfunnel.appspot.com/o/doggo_shop_logo_3x.png?alt=media&token=a133b491-3af3-4dc2-88ce-9328413a4773" height="56.25">
        </td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="1995753e-0c64-4075-b4ad-321980b82dfe">
    <tbody>
      <tr>
        <td style="padding:100px 0px 18px 0px; line-height:36px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="color: #ffffff; font-size: 40px; font-family: inherit">Thank you for your order!</span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="2ffbd984-f644-4c25-9a1e-ef76ac62a549">
    <tbody>
      <tr>
        <td style="padding:18px 20px 20px 0px; line-height:24px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="font-size: 24px">Now you can relax. We're workin on</span></div>
<div style="font-family: inherit; text-align: inherit"><span style="font-size: 24px">getting your DoggoBox to you ASAP!</span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" class="module" data-role="module-button" data-type="button" role="module" style="table-layout:fixed;" width="100%" data-muid="69fc33ea-7c02-45ed-917a-b3b8a6866e89">
      <tbody>
        <tr>
          <td align="left" bgcolor="" class="outer-td" style="padding:0px 0px 0px 0px;">
            <table border="0" cellpadding="0" cellspacing="0" class="wrapper-mobile" style="text-align:center;">
              <tbody>
                <tr>
                <td align="center" bgcolor="#000000" class="inner-td" style="border-radius:6px; font-size:16px; text-align:left; background-color:inherit;">
                  
                </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table></td>
              </tr>
            </tbody>
          </table>
          
        </td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="8b5181ed-0827-471c-972b-74c77e326e3d">
    <tbody>
      <tr>
        <td style="padding:30px 20px 18px 30px; line-height:22px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="color: #0055ff; font-size: 24px">Order Summary</span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="divider" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="f7373f10-9ba4-4ca7-9a2e-1a2ba700deb9">
    <tbody>
      <tr>
        <td style="padding:0px 30px 0px 30px;" role="module-content" height="100%" valign="top" bgcolor="">
          <table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" height="3px" style="line-height:3px; font-size:3px;">
            <tbody>
              <tr>
                <td style="padding:0px 0px 3px 0px;" bgcolor="#e7e7e7"></td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="264ee24b-c2b0-457c-a9c1-d465879f9935">
    <tbody>
      <tr>
        <td style="padding:18px 20px 18px 30px; line-height:22px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit"><span style="color: #0055ff"><strong>Transaction Number: NT029811</div>
<div style="font-family: inherit; text-align: inherit"><br></div>
<div style="font-family: inherit; text-align: inherit">Order From: ${customerName}</div>
<div style="font-family: inherit; text-align: inherit">${customerAddress.line1}, ${customerAddress.city}, ${customerAddress.state}&nbsp;</div><div></div></div></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:20px 20px 0px 30px;" bgcolor="#FFFFFF">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top">
          <table class="column" width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="wrapper" role="module" data-type="image" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="239f10b7-5807-4e0b-8f01-f2b8d25ec9d7">
    <tbody>
      <tr>
        <td style="font-size:6px; line-height:10px; padding:0px 0px 0px 0px;" valign="top" align="left">
          <img class="max-width" border="0" style="display:block; color:#000000; text-decoration:none; font-family:Helvetica, arial, sans-serif; font-size:16px;" width="125" alt="" data-proportionally-constrained="true" data-responsive="false" src="https://firebasestorage.googleapis.com/v0/b/doggobox-clickfunnel.appspot.com/o/doggo_box_3x.png?alt=media&token=14bdbfa8-fa2e-4049-8f92-07655c891f3a" height="125">
        </td>
      </tr>
    </tbody>
  </table></td>
              </tr>
            </tbody>
          </table>
          <table class="column" width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="f404b7dc-487b-443c-bd6f-131ccde745e2">
    <tbody>
      <tr>
        <td style="padding:18px 0px 18px 0px; line-height:22px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">$1 DoggoBox</div>
<div style="font-family: inherit; text-align: inherit"><br></div>
<div style="font-family: inherit; text-align: inherit"><span style="color: #0055ff">$1.00&nbsp;</span></div><div></div></div></td>
      </tr>
    </tbody>
  </table></td>
              </tr>
            </tbody>
          </table>
        <table width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-2">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"></td>
        </tr>
      </tbody>
    </table><table width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-3">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:20px 20px 0px 30px;" bgcolor="#FFFFFF">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top">
          <table class="column" width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="wrapper" role="module" data-type="image" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="239f10b7-5807-4e0b-8f01-f2b8d25ec9d7.1">
    <tbody>
      <tr>
       
      </tr>
    </tbody>
  </table></td>
              </tr>
            </tbody>
          </table>
          <table class="column" width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="f404b7dc-487b-443c-bd6f-131ccde745e2.1">

  </table></td>
              </tr>
            </tbody>
          </table>
        <table width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-2">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"></td>
        </tr>
      </tbody>
    </table><table width="137" style="width:137px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-3">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="divider" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="f7373f10-9ba4-4ca7-9a2e-1a2ba700deb9.1">
    <tbody>
      <tr>
        <td style="padding:20px 30px 0px 30px;" role="module-content" height="100%" valign="top" bgcolor="">
          <table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" height="3px" style="line-height:3px; font-size:3px;">
            <tbody>
              <tr>
                <td style="padding:0px 0px 3px 0px;" bgcolor="E7E7E7"></td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="264ee24b-c2b0-457c-a9c1-d465879f9935.1">
    <tbody>
      <tr>
        <td style="padding:18px 20px 30px 30px; line-height:22px; text-align:inherit;" height="100%" valign="top" bgcolor="" role="module-content"><div><div style="font-family: inherit; text-align: inherit">Subtotal - $1.00</div>
<div style="font-family: inherit; text-align: inherit">Taxes - $0.00</div>
<div style="font-family: inherit; text-align: inherit">Shipping - $0.00</div>
<div style="font-family: inherit; text-align: inherit"><br>
Grand Total&nbsp;</div>
<div style="font-family: inherit; text-align: inherit"><br></div>
<div style="font-family: inherit; text-align: inherit"><span style="color: #0055ff; font-size: 32px; font-family: inherit">$1.00</span></div><div></div></div></td>
      </tr>
    </tbody>
  </table><table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" role="module" data-type="columns" style="padding:0px 20px 0px 20px;" bgcolor="#0055ff">
    <tbody>
      <tr role="module-content">
        <td height="100%" valign="top">
          <table class="column" width="140" style="width:140px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9d43ffa1-8e24-438b-9484-db553cf5b092">
    <tbody>
      <tr>
      
      </tr>
    </tbody>
  </table></td>
              </tr>
            </tbody>
          </table>
          <table class="column" width="140" style="width:140px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="">
            <tbody>
              <tr>
                <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9d43ffa1-8e24-438b-9484-db553cf5b092.1">
    <tbody>
      <tr>
     
      </tr>
    </tbody>
  </table></td>
              </tr>
            </tbody>
          </table>
        <table width="140" style="width:140px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-2">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9d43ffa1-8e24-438b-9484-db553cf5b092.1.1">
    <tbody>
      <tr>
    
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table><table width="140" style="width:140px; border-spacing:0; border-collapse:collapse; margin:0px 0px 0px 0px;" cellpadding="0" cellspacing="0" align="left" border="0" bgcolor="" class="column column-3">
      <tbody>
        <tr>
          <td style="padding:0px;margin:0px;border-spacing:0;"><table class="module" role="module" data-type="text" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout: fixed;" data-muid="9d43ffa1-8e24-438b-9484-db553cf5b092.1.1.1">
    <tbody>
      <tr>
        
      </tr>
    </tbody>
  </table></td>
        </tr>
      </tbody>
    </table></td>
      </tr>
    </tbody>
  </table><div data-role="module-unsubscribe" class="module" role="module" data-type="unsubscribe" style="background-color:#0055ff; color:#ffffff; font-size:12px; line-height:20px; padding:16px 16px 16px 16px; text-align:Center;" data-muid="4e838cf3-9892-4a6d-94d6-170e474d21e5">
                                            <div class="Unsubscribe--addressLine"><p class="Unsubscribe--senderName" style="font-size:16px; line-height:20px;">Doggo Brand</p><p style="font-size:12px; line-height:20px;"><span class="Unsubscribe--senderAddress">1519 Shipman Blvd</span>, <span class="Unsubscribe--senderCity">Birmingham</span>, <span class="Unsubscribe--senderState">Michigan</span> <span class="Unsubscribe--senderZip">48009</span></p></div>
                                            
                                          </div><table border="0" cellpadding="0" cellspacing="0" class="module" data-role="module-button" data-type="button" role="module" style="table-layout:fixed;" width="100%" data-muid="e5cea269-a730-4c6b-8691-73d2709adc62">
      <tbody>
        <tr>
          <td align="center" bgcolor="0055FF" class="outer-td" style="padding:0px 0px 20px 0px;">
   
          </td>
        </tr>
      </tbody>
    </table></td>
                                      </tr>
                                    </tbody></table>
                                    <!--[if mso]>
                                  </td>
                                </tr>
                              </table>
                            </center>
                            <![endif]-->
                          </td>
                        </tr>
                      </tbody></table>
                    </td>
                  </tr>
                </tbody></table>
              </td>
            </tr>
          </tbody></table>
        </div>
      </center>
    
  
</body></html>
`
      };

      transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
          console.log(error);
        } else {
          console.log('Email sent: ' + info.response);
        }
      });

    } catch (error) {
      // We want to capture errors and render them in a user-friendly way, while
      // still logging an exception with StackDriver
      console.log(error);
    }
  });


/**
 * When 3D Secure is performed, we need to reconfirm the payment
 * after authentication has been performed.
 *
 * @see https://stripe.com/docs/payments/accept-a-payment-synchronously#web-confirm-payment
 */
exports.confirmStripePayment = functions.firestore
  .document('customers/{userId}/payments/{pushId}')
  .onUpdate(async (change, context) => {
    if (change.after.data().status === 'requires_confirmation') {
      const payment = await stripe.paymentIntents.confirm(
        change.after.data().id
      );
      change.after.ref.set(payment);
    }
  });

/**
 * When a subscription document is written on the client
 * this function is triggered to create the subscription in Stripe.
 *
 * @see https://stripe.com/docs/payments/save-and-reuse#web-create-payment-intent-off-session
 */

// [START subscribecustomer]
exports.createStripeSubscription = functions.firestore.document('customers/{userID}/subscriptions/{pushId}').onCreate(async (snap, context) => {
  const { customer_id, items, payment_method } = snap.data();
  try {

    // Look up the Stripe customer id.
    const customerId = (await snap.ref.parent.parent.get()).data().customer_id;

    const firstDayNextMonth = dayjs().add(1, 'M').startOf('M').unix();
    // const currentDay = dayjs();
    // let dayDifference = firstDayNextMonth.diff(currentDay, 'd');


    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: items,
      trial_end: firstDayNextMonth,
    });
    // If the result is successful, write it back to the database.
    await snap.ref.set(subscription);
  } catch (error) {
    // We want to capture errors and render them in a user-friendly way, while
    // still logging an exception with StackDriver
    console.log(error);
  }
});