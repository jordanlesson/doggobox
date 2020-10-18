import 'index.dart';
import 'package:doggobox/view_controller.dart';

void main() {
  runApp(DoggoBox());
}

class DoggoBox extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get your DoggoBox for only \$1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Color.fromRGBO(35, 193, 255, 0.25),
        fontFamily: "Poppins",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Color(0xFF23C1FF),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 35.0,
            fontWeight: FontWeight.w600,
            height: 1.252,
          ),
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: ViewController(
        desktopPage: OrderConfirmationPageDesktop(),
        mobilePage: OrderConfirmationPageMobile(),
      ),
    );
  }
}
