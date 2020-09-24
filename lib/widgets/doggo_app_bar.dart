import 'package:doggobox/index.dart';

class DoggoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int step;

  @override
  final Size preferredSize;

  DoggoAppBar({
    this.step,
    this.preferredSize,
  });

  Widget _buildLeading() {
    return Container(
      child: Text(
        step != 4 ? "Step $step of 4" : "Last Step",
        style: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      // height: 39.0,
      width: 105.23,
      child: Image(
        image: AssetImage(
          "assets/doggo_shop_logo_2x.png",
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      child: Text(
        step != 4 ? "Step $step of 4" : "Last Step",
        style: TextStyle(
          color: Colors.transparent,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        height: 75.0,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLeading(),
                  _buildTitle(),
                  _buildPlaceholder(),
                ],
              ),
            ),
            Stack(
              children: [
                Row(
                  children: List<Widget>.generate(
                    step,
                    (index) {
                      return Container(
                        height: 5.0,
                        width: screenWidth * 0.25,
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 5.0,
                    width: screenWidth * 0.0625,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
