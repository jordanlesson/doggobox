import 'package:doggobox/index.dart';

class Testimonial extends StatelessWidget {
  final String imagePath;
  final String review;
  final String name;

  Testimonial({
    this.imagePath,
    this.review,
    this.name,
  });

  Widget _buildImage() {
    return Container(
      height: 164.0,
      width: 164.0,
      child: Image(
        image: AssetImage(imagePath),
      ),
    );
  }

  Widget _buildReview(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        review,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Container(
      child: Text(
        name.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: [
          _buildImage(),
          _buildReview(context),
          _buildName(context),
        ],
      ),
    );
  }
}
