import 'package:doggobox/index.dart';

class OrderConfirmationPageDesktop extends StatefulWidget {
  @override
  _OrderConfirmationPageDesktopState createState() =>
      _OrderConfirmationPageDesktopState();
}

class _OrderConfirmationPageDesktopState
    extends State<OrderConfirmationPageDesktop> {
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerCenterRight;

  @override
  void initState() {
    super.initState();
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 2));

    _controllerCenterLeft..play();
    _controllerCenterRight..play();
  }

  @override
  void dispose() {
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return Container(
      height: 70.0,
      color: Colors.white,
      alignment: Alignment.center,
      child: Container(
        height: 39.0,
        width: 105.23,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/doggo_shop_logo_2x.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderConfirmation() {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
      child: Container(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Order Confirmed 🎉",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 48.0),
              ),
              TextSpan(
                text: "\nWoof woof 🐶",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 48.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGif() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          image: DecorationImage(
            image: AssetImage(
              "assets/dogs_excited.gif",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildThankYou() {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 50.0),
      child: Column(
        children: [
          Container(
            child: Text(
              "Your Doggo will thank you!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 36.0),
            ),
          ),
          Container(
            height: 10.0,
          ),
          Container(
            child: Text(
              "You will receive an order confirmation to your email shortly.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 4.0),
              blurRadius: 4.0,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Follow us on Instagram",
                style: Theme.of(context).textTheme.button,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 30.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
      onTap: () async {
        const url = "https://www.instagram.com/thedoggobox/";
        if (await canLaunch(url)) {
          launch(url);
        }
      },
    );
  }

  Widget _buildBadge() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        //color: Colors.green,
        constraints: BoxConstraints(
          maxWidth: 432.0,
        ),
        child: Image(
          image: AssetImage("assets/badge_desktop_2x.png"),
        ),
      ),
    );
  }

  Widget _buildConfettiLeft() {
    return Positioned(
      left: 50.0,
      top: -20.0,
      child: ConfettiWidget(
        confettiController: _controllerCenterLeft,
        blastDirectionality: BlastDirectionality.explosive,
        //blastDirection: pi / 6.0, // radial value - LEFT
        particleDrag: 0.05, // apply drag to the confetti
        emissionFrequency: 0.05, // how often it should emit
        numberOfParticles: 50, // number of particles to emit
        gravity: 0.2, // gravity - or fall speed
        colors: [
          Theme.of(context).accentColor.withOpacity(1.0),
          Color(0xFFFF23A7),
          Theme.of(context).accentColor.withOpacity(1.0),
          Color(0xFFFF23A7),
          Colors.green,
          Colors.orange,
          Colors.purple
        ], // manually specify the colors to be used
      ),
    );
  }

  Widget _buildConfettiCenter() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controllerCenterRight,
        blastDirectionality: BlastDirectionality.explosive,
        //blastDirection: 5.0 * pi / 6.0, // radial value - LEFT
        particleDrag: 0.05, // apply drag to the confetti
        emissionFrequency: 0.05, // how often it should emit
        numberOfParticles: 50, // number of particles to emit
        gravity: 0.2, // gravity - or fall speed
        shouldLoop: false,
        colors: [
          Theme.of(context).accentColor.withOpacity(1.0),
          Color(0xFFFF23A7),
          Theme.of(context).accentColor.withOpacity(1.0),
          Color(0xFFFF23A7),
          Colors.green,
          Colors.orange,
          Colors.purple
        ], // manually specify the colors to be used
      ),
    );
  }

  Widget _buildConfettiRight() {
    return Positioned(
      right: 50.0,
      top: -20.0,
      child: ConfettiWidget(
        confettiController: _controllerCenterRight,
        blastDirectionality: BlastDirectionality.explosive,
        //blastDirection: 5.0 * pi / 6.0, // radial value - LEFT
        particleDrag: 0.05, // apply drag to the confetti
        emissionFrequency: 0.05, // how often it should emit
        numberOfParticles: 50, // number of particles to emit
        gravity: 0.2, // gravity - or fall speed
        shouldLoop: false,
        colors: [
          Theme.of(context).accentColor.withOpacity(1.0),
          Color(0xFFFF23A7),
          Theme.of(context).accentColor.withOpacity(1.0),
          Color(0xFFFF23A7),
          Colors.green,
          Colors.orange,
          Colors.purple
        ], // manually specify the colors to be used
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            padding: EdgeInsets.fromLTRB(
              56.0,
              0.0,
              56.0,
              100.0,
            ),
            children: [
              _buildAppBar(),
              _buildOrderConfirmation(),
              Container(
                constraints: BoxConstraints(maxHeight: 568.0),
                child: Row(
                  children: [
                    _buildGif(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 56.0),
                        child: Column(
                          children: [
                            _buildThankYou(),
                            _buildButton(),
                            Expanded(
                              child: Container(),
                            ),
                            _buildBadge(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildConfettiLeft(),
        _buildConfettiCenter(),
        _buildConfettiRight(),
      ],
    );
  }
}
