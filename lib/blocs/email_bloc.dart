import 'package:doggobox/index.dart';

class EmailBloc extends BlocBase {
  // STREAMS OF EMAIL TEXT FIELD
  StreamController<bool> streamListController =
      StreamController<bool>.broadcast();

  // SINK
  Sink<bool> get emailSink => streamListController.sink;

  // STREAM
  Stream<bool> get emailStream => streamListController.stream;

  // FUNCTION TO CHECK WHETHER EMAIL IS VALID
  void checkEmail(String email) {
    emailSink.add(Validators.isEmailValid(email));
  }

  // DISPOSING EMAIL STREAM
  @override
  dispose() {
    streamListController.close();
  }
}