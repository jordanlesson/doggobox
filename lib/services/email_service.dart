import 'package:doggobox/index.dart';

class EmailService {
  Future<void> sendOrderConfirmationEmail(List<String> recipients) async {
    final Email email = Email(
      recipients: recipients,
      subject: "We've Received Your Order!",
      body: "Order Confirmation",
      isHTML: false,
      attachmentPaths: [],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = "Order Confirmation Email Sent";
    } catch (error) {
      platformResponse = error.toString();
    }
  }
}
