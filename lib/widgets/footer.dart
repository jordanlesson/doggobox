import 'package:doggobox/index.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 227.0,
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Color(0xFFFCFCFC),
        border: Border(
          top: BorderSide(
            color: Colors.black26,
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "About Doggo Brand",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Text(
                  "Contact Us",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Text(
                  "Manage Subscription",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            "© 2020 Doggo Brand. All Rights Reserved",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
