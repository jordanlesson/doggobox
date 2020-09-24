import 'package:doggobox/index.dart';

class CheckOutBloc extends BlocBase {
  // STREAM OF CHECK OUT FORM
  StreamController<bool> checkOutStreamListController =
      StreamController<bool>.broadcast();

  // SINK
  Sink<bool> get checkOutSink => checkOutStreamListController.sink;

  // STREAM
  Stream<bool> get checkOutStream => checkOutStreamListController.stream;

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
    if (customer.isNameValid() &&
        DoggoCreditCard().checkCreditCardInfo(card) &&
        address.isAddressInfoValid()) {
      checkOutSink.add(true);
    } else {
      checkOutSink.add(false);
    }
  }

  void onDoggoBoxPurchased(BuildContext context, String email,
      Customer customer, CreditCard card, Address address) async {
    transactionSink.add(FirestoreResponse(
      message: "loading",
      success: false,
    ));

    try {
      FirebaseAuthResponse authResponse =
          await FirebaseService.createUser(email);

      if (authResponse.success) {
        // Add shipping to customer
        await FirebaseService.updateCustomerInfo(
          user: authResponse.user,
          address: address,
          name: customer.name,
        );

        // Create payment method with Stripe
        PaymentMethod paymentMethod =
            await StripeService.createPaymentMethod(card);

        // Adds payment method to Firestore
        FirestoreResponse paymentMethodResponse =
            await FirebaseService.createPaymentMethod(
                authResponse.user, paymentMethod);

        if (paymentMethodResponse.success) {
          Payment payment = await FirebaseService.createPayment(
            authResponse.user,
            amount: 500,
            currency: "usd",
            paymentMethod: paymentMethod,
          );

          // Initializes payment status to processing
          String paymentStatus = "processing";
          Timer timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
            print("Payment Status: $paymentStatus");
            paymentStatus = await FirebaseService.checkPaymentStatus(
                authResponse.user, payment);

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
                      child: OneTimeOfferPage(
                        user: authResponse.user,
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
      }
      return;
    } catch (error) {
      transactionSink.add(FirestoreResponse(
        message: "Credit Card is Invalid. Please Try Again",
        success: false,
      ));
    }
  }

  // DISPOSING CHECK OUT STREAM
  @override
  dispose() {
    checkOutStreamListController.close();
    transactionStreamListController.close();
  }
}
