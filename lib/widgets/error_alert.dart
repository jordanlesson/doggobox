import 'package:doggobox/index.dart';

class ErrorAlert extends StatelessWidget {
  final String errorText;
  const ErrorAlert({@required this.errorText, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            //margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).errorColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Text(
              errorText,
              style: Theme.of(context).textTheme.overline,
            ),
          ),
        ),
        CustomPaint(
          painter: TrianglePainter(
            strokeColor: Theme.of(context).errorColor,
            paintingStyle: PaintingStyle.fill,
          ),
          child: Container(
            height: 6.0,
            width: 10.0,
          ),
        ),
      ],
    );
  }
}
