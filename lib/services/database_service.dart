import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggobox/index.dart';

class FirestoreResponse {
  String message;
  bool success;
  FirestoreResponse({this.message, this.success});
}

class FirebaseAuthResponse {
  User user;
  String message;
  bool success;

  FirebaseAuthResponse({this.user, this.message, this.success});
}

class FirebaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<FirebaseAuthResponse> createUser(String email) async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: 'turtletown18',
      );

      return FirebaseAuthResponse(
          user: user.user,
          message: "Customer Created: ${user.user.email}",
          success: true);
    } catch (error) {
      return FirebaseAuthResponse(
        user: null,
        message: "Failed To Create Customer: $error",
        success: false,
      );
    }
  }

  static Future<FirestoreResponse> createPaymentMethod(
      User user, PaymentMethod paymentMethod) async {
    try {
      await firestore
          .doc("customers/${user.uid}/payment_methods/${paymentMethod.id}")
          .set(
        {
          "id": paymentMethod.id,
          "customer_id": paymentMethod.customerId,
          "type": "card",
        },
      );
      print("Successfully Created Payment Method: ${paymentMethod.id}");
      return FirestoreResponse(
          message: "Successfully Created Payment Method: ${paymentMethod.id}",
          success: true);
    } catch (error) {
      print("Failed to Create Payment Method: $error");
      return FirestoreResponse(
          message: "Failed to Create Payment Method: $error", success: false);
    }
  }

  static Future<Payment> createPayment(User user,
      {int amount, String currency, PaymentMethod paymentMethod}) async {
    try {
      DocumentReference paymentRef =
          await firestore.collection("customers/${user.uid}/payments/").add(
        {
          "amount": amount,
          "currency": currency,
          "payment_method": paymentMethod.id,
          "status": "processing",
        },
      );

      final Payment payment = Payment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod.id,
        id: paymentRef.id,
      );

      return payment;
    } catch (error) {
      return null;
    }
  }

  static Future<Subscription> createSubscription(
      User user, List<Price> items, PaymentMethod paymentMethod) async {
    try {
      Customer customer = await retrieveCustomerDetails(user);

      DocumentReference subscriptionRef = await firestore
          .collection("customers/${user.uid}/subscriptions/")
          .add(
        {
          "customer_id": customer.customerId,
          "items": List.generate(items.length, (index) {
            return {"price": items[index].id};
          }),
          "payment_method": paymentMethod.id,
        },
      );

      final Subscription subscription = Subscription(
        items: items,
      );

      print("Subscription added to Firebase");
      return subscription;
    } catch (error) {
      print("Error creating subscription: $error");
      return null;
    }
  }

  static Future<void> updateCustomerInfo(
      {User user, String name, Address address}) async {
    try {
      print(user.uid);
      return await firestore.doc("customers/${user.uid}").set(
        {
          "name": name,
          "address": {
            "line1": address.line1,
            "city": address.city,
            "country": "United States",
            "postal_code": address.postalCode,
            "state": address.state,
          },
          "shipping": {
            "address": {
              "line1": address.line1,
              "city": address.city,
              "country": "United States",
              "postal_code": address.postalCode,
              "state": address.state,
            },
            "name": name,
          },
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      print("Error Occurred While Updating Customer: $error");
    }
  }

  static Future<PaymentMethod> retrievePaymentMethod(User user) async {
    try {
      QuerySnapshot customerSnapshot = await firestore
          .collection("customers/${user.uid}/payment_methods")
          .get();

      String paymentMethodId = customerSnapshot.docs[0].id;

      PaymentMethod paymentMethod = PaymentMethod(
        id: paymentMethodId,
      );
      return paymentMethod;
    } catch (error) {
      print("An error occurred while retrieving customer details: $error");
      return null;
    }
  }

  static Future<Customer> retrieveCustomerDetails(User user) async {
    try {
      DocumentSnapshot customerSnapshot =
          await firestore.doc("customers/${user.uid}").get();

      Customer customer =
          Customer(customerId: customerSnapshot.data()["customer_id"]);

      return customer;
    } catch (error) {
      print("An error occurred while retrieving customer details: $error");
      return null;
    }
  }

  static Future<String> checkPaymentStatus(User user, Payment payment) async {
    try {
      DocumentSnapshot paymentSnapshot = await firestore
          .doc("customers/${user.uid}/payments/${payment.id}")
          .get();

      if (paymentSnapshot.exists) {
        Map<String, dynamic> paymentInfo = paymentSnapshot.data();

        return paymentInfo["status"];
      }

      return "canceled";
    } catch (error) {
      return "canceled";
    }
  }
}
