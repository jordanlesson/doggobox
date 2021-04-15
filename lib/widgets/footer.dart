import 'package:doggobox/index.dart';

class Footer extends StatelessWidget {
  void _launchManageSubscriptionEmail() async {
    final mailtoLink = Mailto(
      to: ['contact@thedoggobox.com'],
      //cc: ['cc1@example.com', 'cc2@example.com'],
      subject: 'Manage My DoggoBox Subscription',
      body: "Hi there,\n\nI'd like to manage my subscription.",
    );

    await launch('$mailtoLink');
  }

  void _launchContactUsEmail() async {
    final mailtoLink = Mailto(
      to: ['contact@thedoggobox.com'],
      //cc: ['cc1@example.com', 'cc2@example.com'],
      subject: "DoggoBox Question",
      body: "Hi there,\n\nI'd like to...",
    );

    await launch('$mailtoLink');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
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
          GestureDetector(
            child: Container(
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
            onTap: _launchContactUsEmail,
          ),
          GestureDetector(
            child: Container(
              color: Colors.transparent,
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
            onTap: _launchManageSubscriptionEmail,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "*IF ABOVE LINKS DO NOT WORK, EMAIL US AT ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "CONTACT@THEDOGGOBOX.COM",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: " FOR ANY QUESTIONS",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
