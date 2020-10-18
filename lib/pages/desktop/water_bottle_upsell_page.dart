import 'package:doggobox/index.dart';

class WaterBottleUpsellPageDesktop extends StatefulWidget {
  final List<Product> cart;
  final User user;

  WaterBottleUpsellPageDesktop({
    @required this.cart,
    @required this.user,
  });

  @override
  _WaterBottleUpsellPageDesktopState createState() =>
      _WaterBottleUpsellPageDesktopState();
}

class _WaterBottleUpsellPageDesktopState
    extends State<WaterBottleUpsellPageDesktop> {
  VideoPlayerController _videoPlayerController;
  ShoppingCartBloc shoppingCartBloc;
  List<Product> cart;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset("assets/dog_drinking_water.mov");

    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.setVolume(0.0);
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((_) => setState(() {}));
    _videoPlayerController.play();

    shoppingCartBloc = ShoppingCartBloc();
    cart = List<Product>.from(widget.cart);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    shoppingCartBloc.dispose();
    super.dispose();
  }

  Widget _buildStepCounter() {
    return Container(
      padding: EdgeInsets.only(
        top: 20.0,
      ),
      alignment: Alignment.topLeft,
      child: Text(
        "Step 3 of 4",
        style: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOffer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 25.0,
      ),
      constraints: BoxConstraints(maxWidth: 120.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "50% OFF",
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Theme.of(context).accentColor.withOpacity(1.0),
                    fontSize: 48.0,
                  ),
            ),
            TextSpan(
              text: "\nThe Reusable Dog Water Bottle",
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: 48.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTrick() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.centerLeft,
      child: Container(
        height: 35.0,
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: 576.0),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "YOU CAN HELP SAVE ANIMALS TODAY".toUpperCase(),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionalImage() {
    return Container(
      padding: EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Color(0xFFE5E5E5),
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 687.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(
              "assets/dog_water_bottle_3x.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildOneTimeOffer() {
    return Container(
      padding: EdgeInsets.only(left: 56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "Don't Let Your Doggo Go Thirsty 💦",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontSize: 35.0),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              "You will never have to carry around a doggy bowl again! We know how incovenient it can be to lug around both a water bottle & a doggy bowl every single time you go out with your dog.\n\nOur Portable Dog Water Bottle solves this problem it acts as BOTH the water bowl & the water carrier in an easy to dispense container. Keep your dog healthy & get yours now!",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 18.0),
            ),
          ),
          GestureDetector(
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
              child: Text(
                "Get The Doggo Water Bottle for only \$31.99",
                style: Theme.of(context).textTheme.button,
              ),
            ),
            onTap: () {
              cart.add(ReusableDogWaterBottle());
              _navigateToNextStep(cart);
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 40.0),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "No thanks, I don't want to at this time",
                      style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 22.0,
                      color: Theme.of(context).accentColor.withOpacity(1.0),
                    ),
                  ],
                ),
              ),
              onTap: () => _navigateToNextStep(cart),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              //color: Colors.green,
              constraints: BoxConstraints(
                maxWidth: 432.0,
              ),
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Image(
                image: AssetImage("assets/badge_desktop_2x.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalImage2() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/dog_water_bottle_2_3x.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    return AspectRatio(
      aspectRatio: 9.0 / 16.0,
      child: Container(
        color: Colors.black12,
        child: VideoPlayer(_videoPlayerController),
      ),
    );
  }

  Widget _buildOneTimeOffer2() {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              "Your Doggo Will Love You!",
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 100.0,
              constraints: BoxConstraints(maxWidth: 610.0),
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
              child: Text(
                "Get The Doggo Water Bottle for only \$31.99",
                style: Theme.of(context).textTheme.button,
              ),
            ),
            onTap: () {
              cart.add(ReusableDogWaterBottle());
              _navigateToNextStep(cart);
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 40.0),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "No thanks, I don't want to at this time",
                      style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 22.0,
                      color: Theme.of(context).accentColor.withOpacity(1.0),
                    ),
                  ],
                ),
              ),
              onTap: () => _navigateToNextStep(cart),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextStep(List<Product> cart) {
    // Purchases everything added to cart
    shoppingCartBloc.onFinishedShopping(widget.user, cart);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: ViewController(
              mobilePage: OrderConfirmationPageMobile(),
              desktopPage: OrderConfirmationPageDesktop(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: DoggoAppBar(
      //   preferredSize: Size.fromHeight(100.0),
      //   desktop: true,
      //   step: 3,
      // ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(56.0, 0.0, 56.0, 100.0),
        children: [
          _buildStepCounter(),
          _buildOffer(),
          _buildSalesTrick(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildPromotionalImage(),
              ),
              Expanded(
                child: _buildOneTimeOffer(),
              ),
            ],
          ),
          Container(
            height: 100.0,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 800.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPromotionalImage2(),
                ),
                Container(width: 40.0),
                Expanded(
                  flex: 1,
                  child: _buildVideo(),
                ),
              ],
            ),
          ),
          _buildOneTimeOffer2(),
        ],
      ),
    );
  }
}
