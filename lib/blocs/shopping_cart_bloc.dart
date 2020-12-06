import 'package:doggobox/index.dart';

class ShoppingCartBloc extends BlocBase {
  // STREAMS OF SHOPPING CART
  StreamController<List<Product>> streamListController =
      StreamController<List<Product>>.broadcast();

  // SINK
  Sink<List<Product>> get shoppingCartSink => streamListController.sink;

  // STREAM
  Stream<List<Product>> get shoppingCartStream => streamListController.stream;

  // FUNCTION THAT ADDS ITEM TO SHOPPING CART
  void addProductToCart(Product product) async {
    List<Product> products = List.from(await shoppingCartStream.last);
    products.add(product);
    print("Product Added: $products");
    shoppingCartSink.add(products);
  }

  // COMPLETES TRANSACTION FOR ITEM WHEN ADDED TO CART
  void checkOutItem(User user, Product product) async {
    try {
      Price price = await StripeService.createPrice(product,
          currency: "usd",
          unitAmount: product.price,
          nickname: product.name,
          interval: PaymentInterval.month);

      PaymentMethod paymentMethodId =
          await FirebaseService.retrievePaymentMethod(user);

      if (price != null) {
        if (product.name == "Reusable Dog Water Bottle") {
          Payment payment = await FirebaseService.createPayment(user,
              amount: product.price,
              currency: "usd",
              paymentMethod: paymentMethodId);
        } else {
          await FirebaseService.createSubscription(
            user,
            [price],
            paymentMethodId,
          );
        }
      }
    } catch (error) {
      print("Not able to complete transaction for ${product.name}: $error");
    }
  }

  void onFinishedShopping(User user, List<Product> cart) async {
    try {
      for (Product product in cart) {
        Price price = await StripeService.createPrice(product,
            currency: "usd",
            unitAmount: product.price,
            nickname: product.name,
            interval: PaymentInterval.month);

        PaymentMethod paymentMethodId =
            await FirebaseService.retrievePaymentMethod(user);

        if (price != null) {
          if (product.name == "Reusable Dog Water Bottle") {
            Payment payment = await FirebaseService.createPayment(user,
                amount: product.price,
                currency: "usd",
                paymentMethod: paymentMethodId);
          } else {
            await FirebaseService.createSubscription(
              user,
              [price],
              paymentMethodId,
            );
          }
        }
      }
    } catch (error) {
      print("Not able to complete all of shopping car purchases: $error");
    }
  }

  // DISPOSING SHOPPING CART STREAM
  @override
  dispose() {
    streamListController.close();
  }
}
