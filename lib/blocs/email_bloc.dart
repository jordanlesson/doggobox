import 'package:doggobox/index.dart';

class EmailBloc extends BlocBase {
  // STREAMS OF EMAIL TEXT FIELD
  StreamController<EmailResponse> streamListController =
      StreamController<EmailResponse>.broadcast();

  // SINK
  Sink<EmailResponse> get emailSink => streamListController.sink;

  // STREAM
  Stream<EmailResponse> get emailStream => streamListController.stream;

  // FUNCTION TO CHECK WHETHER EMAIL IS VALID
  void checkEmail(String email) {
    emailSink.add(EmailResponse(
      success: Validators.isEmailValid(email),
      error: false,
      user: null,
      isLoading: false,
    ));
  }

  void onDoggoBoxClaimed(BuildContext context, String email) async {
    // Makes button disabled to show loading
    emailSink.add(EmailResponse(
      user: null,
      error: false,
      success: false,
      isLoading: true,
    ));

    if (Validators.isEmailValid(email)) {
      FirebaseAuthResponse authResponse =
          await FirebaseService.createUser(email);

      if (authResponse.success) {
        emailSink.add(EmailResponse(
          user: null,
          success: false,
          error: false,
          isLoading: false,
        ));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ViewController(
                mobilePage: CreditCardPageMobile(user: authResponse.user),
                desktopPage: CreditCardPageDesktop(user: authResponse.user),
              );
            },
          ),
        );
      } else {
        emailSink.add(EmailResponse(
          user: null,
          success: false,
          error: true,
          isLoading: false,
        ));
      }
    } else {
      emailSink.add(EmailResponse(
        user: null,
        success: false,
        error: true,
        isLoading: false,
      ));
    }
  }

  // DISPOSING EMAIL STREAM
  @override
  dispose() {
    streamListController.close();
  }
}

class EmailResponse {
  User user;
  bool error;
  bool success;
  bool isLoading;

  EmailResponse({
    this.user,
    this.error,
    this.success,
    this.isLoading,
  });
}
