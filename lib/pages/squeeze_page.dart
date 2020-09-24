import 'package:doggobox/index.dart';

class SqueezePage extends StatefulWidget {
  @override
  _SqueezePageState createState() => _SqueezePageState();
}

class _SqueezePageState extends State<SqueezePage> {
  String platform;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildAnnouncement(String platform) {
    return Container(
      color: Theme.of(context).accentColor,
      height: 25.0,
      alignment: Alignment.center,
      child: Text(
        "GET YOUR FIRST DOGGOBOX FOR \$5 & FREE SHIPPING",
        style: TextStyle(
          fontSize: platform == "desktop" ? 16.0 : 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLogo(String platform) {
    if (platform == "desktop") {
      return Positioned(
        left: 56.0,
        top: 27.0,
        child: Container(
          height: 75.0,
          width: 201.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/doggo_shop_logo_2x.png"),
            ),
          ),
        ),
      );
    }
    return Container(
      height: 27.0,
      alignment: Alignment.center,
      child: Container(
        height: 75.0,
        width: 201.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/doggo_shop_logo_2x.png"),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 56.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.only(top: 247.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 167.0,
                  width: 507.0,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Get the DoggoBox for only ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 55.0,
                              fontWeight: FontWeight.w600,
                              height: 1.252),
                        ),
                        TextSpan(
                          text: "\$5",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontSize: 55.0,
                            fontWeight: FontWeight.w300,
                            height: 1.252,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 373.0,
                  child: Text(
                    "A totally customized box of themed toys and goodies for your Doggo 🐶",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 52.0,
                    bottom: 12.0,
                  ),
                  child: Text(
                    "What's your best email? ✉️",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 373.0,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor.withOpacity(1.0),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor.withOpacity(1.0),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor.withOpacity(1.0),
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 25.0,
                        top: 16.0,
                        bottom: 15.0,
                        right: 25.0,
                      ),
                      hintText: "simba@thedoggobox.com",
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        fontSize: 18.0,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Container(
                  height: 71.0,
                  width: 373.0,
                  margin: EdgeInsets.only(top: 18.0),
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
                    "⚡️Claim Your DoggoBox Now⚡️",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 821.0,
            alignment: Alignment.bottomRight,
            child: Container(
              height: 741.0,
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    width: 757.0,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 391.0,
                            width: 757.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                          ),
                        ),
                        Container(
                          height: 550.0,
                          width: 300.0,
                          margin: EdgeInsets.only(right: 150.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/dog_holding_toy_3x.png",
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          height: 468.0,
                          width: 474.0,
                          margin: EdgeInsets.only(right: 400.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/doggo_box_3x.png",
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 142.0,
                      width: 432.0,
                      margin: EdgeInsets.only(top: 27.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 35, 167, 0.15),
                        borderRadius: BorderRadius.circular(21.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 113.0,
                            width: 113.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              height: 88.0,
                              width: 88.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xFFF9F9F9),
                                  width: 7.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                height: 60.91,
                                width: 38.47,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/doggo_with_toys_3x.png",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Container(
                                    child: Text(
                                      "Dedicated to support animal shelters with every purchase",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 3.0),
                                    child: Text(
                                      "Simba The Doggo",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontFamily: "Satisfy",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Chief Doggo Officer",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // DESKTOP LAYOUT
        if (constraints.maxHeight <= 980.0) {
          platform = "mobile";
          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                _buildAnnouncement(platform),
                Stack(
                  children: [_buildLogo(platform), _buildEmailForm()],
                ),
              ],
            ),
          );
        }
        // MOBILE LAYOUT
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              _buildAnnouncement("mobile"),
              Stack(
                children: [_buildLogo("mobile"), _buildEmailForm()],
              ),
            ],
          ),
        );
      },
    );
  }
}
