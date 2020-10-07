import 'package:doggobox/index.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String paymentMethodApiUrl =
      '${StripeService.apiBase}/payment_methods';
  static String subscriptionApiUrl = '${StripeService.apiBase}/subscriptions';
  static String customerApiUrl = '${StripeService.apiBase}/customers';
  static StripeApi stripeApi = Stripe.instance.api;
  static String publishableKey =
      "pk_live_51HHg6zAkuXi8ixMu9LOJ72dupcUqRN1wKb83qQHMAYi2Xn2kJOpiC8VUonKPLmXgW0bTVvuL9xcmGoHv5WtPk1zO00gE1BGg54";
  static String secret =
      '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';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    Stripe.init(publishableKey, returnUrlForSca: "www.thedoggobox.com");
  }

  static Future<PaymentMethod> createPaymentMethod(CreditCard card) async {
    try {
      print("Creating Payment Method");

      Map<String, dynamic> body = {
        'type': 'card',
        'card': {
          'exp_month': card.expMonth.toString(),
          'exp_year': card.expYear.toString(),
          'number': card.number,
          'cvc': card.cvc,
        },
      };

      Map<String, dynamic> response =
          await Stripe.instance.api.createPaymentMethod(body);

      PaymentMethod paymentMethod = PaymentMethod.fromJson(response);

      if (paymentMethod != null) {
        print("Payment Method Created: ${paymentMethod.id}");
        return paymentMethod;
      }

      print("Error Creating Payment Method");
      return null;
    } catch (error) {
      print("Error Creating Payment Method: $error");
      return null;
    }
  }

  static Future<Price> createPrice(Product product,
      {String currency,
      int unitAmount,
      String nickname,
      PaymentInterval interval}) async {
    try {
      print("Creating Payment Method");

      String paymentInterval;
      if (interval == PaymentInterval.day) {
        paymentInterval = "day";
      } else if (interval == PaymentInterval.week) {
        paymentInterval = "week";
      } else if (interval == PaymentInterval.month) {
        paymentInterval = "month";
      } else if (interval == PaymentInterval.year) {
        paymentInterval = "year";
      }

      Map<String, dynamic> body = {
        'unit_amount': unitAmount,
        'currency': currency,
        'recurring': {"interval": paymentInterval},
        'product': product.id,
      };

      StripeApiHandler apiHandler = StripeApiHandler();
      apiHandler.apiVersion = DEFAULT_API_VERSION;
      String path = "/prices";

      Map<String, dynamic> response = await apiHandler.request(
          RequestMethod.post, path, secret, apiHandler.apiVersion,
          params: body);

      Price price = Price.fromJson(response);

      if (price != null) {
        print("Price Created: ${price.id}");
        return price;
      }

      print("Error Creating Payment Method");
      return null;
    } catch (error) {
      print("Error Creating Payment Method: $error");
      return null;
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

  // static Future<void> createPaymentMethod(StripeCard card) async {
  //   try {
  //     var token = await Stripe.instance.createCardToken(card);

  //     if
  //   } catch (error) {
  //     print("Error Creating Payment Method");
  //   }
  // }

  static Future<Map<String, dynamic>> createSubscription(
      Customer customer, String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
