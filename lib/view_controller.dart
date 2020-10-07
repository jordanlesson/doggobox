import 'index.dart';

class ViewController extends StatefulWidget {
  final Widget mobilePage;
  final Widget desktopPage;

  ViewController({
    @required this.mobilePage,
    @required this.desktopPage,
  });

  @override
  _ViewControllerState createState() => _ViewControllerState();
}

class _ViewControllerState extends State<ViewController> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size screenSize = constraints.biggest;
        if (screenSize.width <= 414.0 && screenSize.height <= 896.0) {
          return widget.mobilePage;
        }
        return widget.desktopPage;
      },
    );
  }
}
