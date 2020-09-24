import 'package:doggobox/index.dart';

class DoggoButton extends StatefulWidget {
  final bool enabled;
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  DoggoButton({
    @required this.enabled,
    @required this.text,
    @required this.onPressed,
    this.loading = false,
  }) : assert(loading != null);

  @override
  _DoggoButtonState createState() => _DoggoButtonState();
}

class _DoggoButtonState extends State<DoggoButton> {
  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: widget.enabled ? 1.0 : 0.4,
        child: Container(
          height: 71.0,
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
          child: widget.loading
              ? _buildLoading()
              : Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
      onTap: widget.enabled ? widget.onPressed : null,
    );
  }
}
