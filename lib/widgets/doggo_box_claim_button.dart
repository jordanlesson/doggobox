import 'package:doggobox/index.dart';

class DoggoBoxClaimButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  DoggoBoxClaimButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  _DoggoBoxClaimButtonState createState() => _DoggoBoxClaimButtonState();
}

class _DoggoBoxClaimButtonState extends State<DoggoBoxClaimButton> {
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
      child: Container(
        height: 71.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(21.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 4.0,
              offset: Offset(0.0, 4.0),
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
      onTap: widget.onPressed,
    );
  }
}
