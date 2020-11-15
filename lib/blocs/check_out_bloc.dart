import 'package:doggobox/index.dart';
import 'dart:js' as js;

class CheckOutBloc extends BlocBase {
  // STREAM OF CHECK OUT FORM
  StreamController<CheckOutResponse> checkOutStreamListController =
      StreamController<CheckOutResponse>.broadcast();

  // SINK
  Sink<CheckOutResponse> get checkOutSink => checkOutStreamListController.sink;

  // STREAM
  Stream<CheckOutResponse> get checkOutStream =>
      checkOutStreamListController.stream;

  // STREAM OF TRANSACTION STATUS
  StreamController<FirestoreResponse> transactionStreamListController =
      StreamController<FirestoreResponse>.broadcast();

  // SINK
  Sink<FirestoreResponse> get transactionSink =>
      transactionStreamListController.sink;

  // STREAM
  Stream<FirestoreResponse> get transactionStream =>
      transactionStreamListController.stream;

  void onInfoGiven(Customer customer, CreditCard card, Address address) {
    checkOutSink.add(
      CheckOutResponse(
        isCustomerInfoValid:
            customer.isNameValid() && address.isAddressInfoValid(),
        isCardValid: true,
        isValid: customer.isNameValid() &&
            DoggoCreditCard().checkCreditCardInfo(card) &&
            address.isAddressInfoValid(),
      ),
    );
  }

  void onDoggoBoxPurchased(BuildContext context, User user, Customer customer,
      CreditCard card, Address address) async {
    transactionSink.add(FirestoreResponse(
      message: "loading",
      success: false,
    ));

    checkOutSink.add(
      CheckOutResponse(
        isCustomerInfoValid:
            customer.isNameValid() && address.isAddressInfoValid(),
        isCardValid: DoggoCreditCard().checkCreditCardInfo(card),
        isValid: customer.isNameValid() &&
            DoggoCreditCard().checkCreditCardInfo(card) &&
            address.isAddressInfoValid(),
      ),
    );

    if (customer.isNameValid() &&
        DoggoCreditCard().checkCreditCardInfo(card) &&
        address.isAddressInfoValid()) {
      try {
        // Add shipping to customer
        await FirebaseService.updateCustomerInfo(
          user: user,
          address: address,
          name: customer.name,
        );

        // Create payment method with Stripe
        PaymentMethod paymentMethod =
            await StripeService.createPaymentMethod(card);

        // Adds payment method to Firestore
        FirestoreResponse paymentMethodResponse =
            await FirebaseService.createPaymentMethod(user, paymentMethod);

        if (paymentMethodResponse.success) {
          Payment payment = await FirebaseService.createPayment(
            user,
            amount: 100,
            currency: "usd",
            paymentMethod: paymentMethod,
          );

          // Initializes payment status to processing
          String paymentStatus = "processing";
          Timer timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
            print("Payment Status: $paymentStatus");
            paymentStatus =
                await FirebaseService.checkPaymentStatus(user, payment);

            if (paymentStatus == "succeeded") {
              transactionSink.add(FirestoreResponse(
                message: "Payment Successful",
                success: true,
              ));
              t.cancel();
              // On payment succeeded, navigate to next step
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return new WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: OneTimeOfferPageMobile(
                        user: user,
                      ),
                    );
                  },
                ),
              );
              return;
            } else if (paymentStatus == "canceled") {
              transactionSink.add(FirestoreResponse(
                message: "Credit Card is Invalid. Please Try Again",
                success: false,
              ));
              t.cancel();

              // On payment error, show snack bar with error
              final SnackBar errorSnackBar = SnackBar(
                content: Text(
                  "Credit Card is Invalid. Please Try Again",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );

              Scaffold.of(context).showSnackBar(errorSnackBar);

              return;
            } else if (t.tick >= 15) {
              transactionSink.add(FirestoreResponse(
                message: "Something Went Wrong. Please Try Again Later",
                success: false,
              ));
              t.cancel();
              return;
            }
          });
        }

        return;
      } catch (error) {
        transactionSink.add(FirestoreResponse(
          message: "Credit Card is Invalid. Please Try Again",
          success: false,
        ));
      }
    } else {
      transactionSink.add(FirestoreResponse(
        message: "Credit Card is Invalid. Please Try Again",
        success: false,
      ));
    }
  }

  Future<User> onApplePayPressed(BuildContext context, String email) async {
    transactionSink.add(FirestoreResponse(
      message: "loading",
      success: false,
    ));
    print("Apple Pay Transaction Initiated");

    try {
      FirebaseAuthResponse authResponse =
          await FirebaseService.createUser(email);

      if (authResponse.success) {
        print("Firebase User Created: ${authResponse.user.uid}");
        //js.context.callMethod('createPaymentRequest', [authResponse.user.uid]);
        return authResponse.user;
      }
      return null;
      // // Adds payment method to Firestore
      // FirestoreResponse paymentMethodResponse =
      //     await FirebaseService.createPaymentMethod(
      //         authResponse.user, paymentMethod);

      //     if (paymentMethodResponse.success) {
      //       // Payment payment = await FirebaseService.createPayment(
      //       //   authResponse.user,
      //       //   amount: 500,
      //       //   currency: "usd",
      //       //   paymentMethod: paymentMethod,
      //       // );

      //       // Initializes payment status to processing
      //       String paymentStatus = "processing";
      //       Timer timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      //         print("Payment Status: $paymentStatus");
      //         paymentStatus = await FirebaseService.checkPaymentStatus(
      //             authResponse.user, payment);

      //         if (paymentStatus == "succeeded") {
      //           transactionSink.add(FirestoreResponse(
      //             message: "Payment Successful",
      //             success: true,
      //           ));
      //           t.cancel();
      //           // On payment succeeded, navigate to next step
      //           Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) {
      //                 return new WillPopScope(
      //                   onWillPop: () async {
      //                     return false;
      //                   },
      //                   child: OneTimeOfferPage(
      //                     user: authResponse.user,
      //                   ),
      //                 );
      //               },
      //             ),
      //           );
      //           return;
      //         } else if (paymentStatus == "canceled") {
      //           transactionSink.add(FirestoreResponse(
      //             message: "Credit Card is Invalid. Please Try Again",
      //             success: false,
      //           ));
      //           t.cancel();

      //           // On payment error, show snack bar with error
      //           final SnackBar errorSnackBar = SnackBar(
      //             content: Text(
      //               "Credit Card is Invalid. Please Try Again",
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 16.0,
      //                 fontWeight: FontWeight.w500,
      //               ),
      //             ),
      //           );

      //           Scaffold.of(context).showSnackBar(errorSnackBar);

      //           return;
      //         } else if (t.tick >= 15) {
      //           transactionSink.add(FirestoreResponse(
      //             message: "Something Went Wrong. Please Try Again Later",
      //             success: false,
      //           ));
      //           t.cancel();
      //           return;
      //         }
      //       });
      //     }
      //   }
      //   return;
    } catch (error) {
      transactionSink.add(FirestoreResponse(
        message: "Credit Card is Invalid. Please Try Again: $error",
        success: false,
      ));
      return null;
    }
  }

  // DISPOSING CHECK OUT STREAM
  @override
  dispose() {
    checkOutStreamListController.close();
    transactionStreamListController.close();
  }
}

class CheckOutResponse {
  bool isCardValid;
  bool isCustomerInfoValid;
  bool isValid;

  CheckOutResponse({
    this.isCardValid,
    this.isCustomerInfoValid,
    this.isValid,
  });
}
