// import 'package:doggobox/index.dart';

// class CustomerBloc extends BlocBase {
//   // STREAM OF CUSTOMER CREATION
//   StreamController<FirebaseResponse> streamListController =
//       StreamController<FirebaseResponse>.broadcast();

//   // SINK
//   Sink<FirebaseResponse> get customerSink => streamListController.sink;

//   // STREAM
//   Stream<FirebaseResponse> get customerStream => streamListController.stream;

//   // FUNCTION THAT HANDLES CREATION OF USER ACCOUNT
//   void onButtonPressed(BuildContext context, String email) async {
//     print("button pressed");

//     // CREATES LOADING STATUS
//     customerSink.add(FirebaseResponse(
//       message: "loading",
//       success: false,
//     ));
//     var response = await FirebaseService.createUser(email);

//     customerSink.add(response);

//     if (response.success) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) {
//             return CreditCardPage(
//               email: email,
//             );
//           },
//         ),
//       );
//     }
//   }

//   // DISPOSING EMAIL STREAM
//   @override
//   dispose() {
//     streamListController.close();
//   }
// }
