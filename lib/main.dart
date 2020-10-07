import 'package:doggobox/pages/desktop/credit_card_page.dart';
import 'package:doggobox/view_controller.dart';
import 'index.dart';

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
        cursorColor: Color.fromRGBO(35, 193, 255, 0.25),
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
        ),
      ),
      home: SqueezePageMobile(),
    );
  }
}
