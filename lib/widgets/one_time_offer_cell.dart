import 'package:doggobox/index.dart';

class OneTimeOfferCell extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String details;
  final String buttonText;
  final VoidCallback onButtonPressed;
  bool desktop;

  OneTimeOfferCell({
    @required this.imagePath,
    @required this.title,
    @required this.subtitle,
    @required this.details,
    @required this.buttonText,
    @required this.onButtonPressed,
    @required this.desktop,
  }) : assert(desktop != null, "Desktop bool cannot be null");

  Widget _buildImage() {
    return Container(
      height: desktop ? 316.0 : 175.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: desktop ? 35.0 : 26.0,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        10.0,
        0.0,
        10.0,
        15.0,
      ),
      alignment: Alignment.topLeft,
      child: Text(
        subtitle,
        style: TextStyle(
          color: Colors.black,
          fontSize: desktop ? 24.0 : 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return OneTimeOfferButton(
        enabled: true, text: buttonText, onPressed: onButtonPressed);
  }

  Widget _buildDetails() {
    return Container(
      padding: EdgeInsets.only(top: desktop ? 20.0 : 10.0),
      child: Text(
        details,
        style: TextStyle(
          color: Color(0xFF999999),
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFFE5E5E5),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildImage(),
            _buildTitle(),
            _buildSubtitle(),
            _buildButton(context),
            _buildDetails(),
          ],
        ),
      ),
    );
  }
}
