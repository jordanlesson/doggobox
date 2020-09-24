import 'package:doggobox/index.dart';

class OneTimeOfferButton extends StatefulWidget {
  final bool enabled;
  final String text;
  final VoidCallback onPressed;

  OneTimeOfferButton({
    @required this.enabled,
    @required this.text,
    @required this.onPressed,
  });

  @override
  _OneTimeOfferButtonState createState() => _OneTimeOfferButtonState();
}

class _OneTimeOfferButtonState extends State<OneTimeOfferButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: widget.enabled ? 1.0 : 0.4,
        child: Container(
          height: 81.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF23C1FF),
            border: Border.all(
              color: Color(0xFF23C1FF),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(21.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 4.0,
                offset: Offset(0.0, 4.0),
                color: Theme.of(context).accentColor.withOpacity(0.29),
              ),
            ],
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      onTap: widget.enabled ? widget.onPressed : null,
    );
  }
}
