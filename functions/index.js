const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { firestore } = require('firebase-admin');
admin.initializeApp();
//const { Logging } = require('@google-cloud/logging');
//const logging = new Logging({
//  projectId: process.env.GCLOUD_PROJECT,
//});
const stripe = require('stripe')(functions.config().stripe.secret, {
  apiVersion: '2020-03-02',
});


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
        country: "United States",
        postal_code: customerInfo.address.postal_code,
        state: customerInfo.address.state
      },
      shipping: {
        address: {
          line1: customerInfo.address.line1,
          city: customerInfo.address.city,
          country: "United States",
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

      const paymentMethod = await stripe.paymentMethods.retrieve(
        paymentMethodId
      );

      // Adds payment method to customer
      const customerPaymentMethod = await stripe.paymentMethods.attach(
        paymentMethodId,
        { customer: customerId }
      );

      const customer = await stripe.customers.update(
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
    try {
      console.log(payment_method);
      // Look up the Stripe customer id.
      const customer = (await snap.ref.parent.parent.get()).data().customer_id;
      // Create a charge using the pushId as the idempotency key
      // to protect against double charges.
      const idempotencyKey = context.params.pushId;
      const payment = await stripe.paymentIntents.create(
        {
          amount,
          currency,
          customer,
          payment_method,
          confirm: true,
          confirmation_method: 'automatic',
          setup_future_usage: 'off_session',
        },
        { idempotencyKey }
      );
      // If the result is successful, write it back to the database.
      await snap.ref.set(payment);
    } catch (error) {
      // We want to capture errors and render them in a user-friendly way, while
      // still logging an exception with StackDriver
      console.log(error);
      await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
      await reportError(error, { user: context.params.userId });
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

    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: items,
      trial_period_days: 30,
    });
    // If the result is successful, write it back to the database.
    await snap.ref.set(subscription);
  } catch (error) {
    // We want to capture errors and render them in a user-friendly way, while
    // still logging an exception with StackDriver
    console.log(error);
    await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
    await reportError(error, { user: context.params.userId });
  }
});