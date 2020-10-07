import 'package:doggobox/index.dart';

class WaterBottleUpsellPageMobile extends StatefulWidget {
  final List<Product> cart;
  final User user;

  WaterBottleUpsellPageMobile({
    @required this.cart,
    @required this.user,
  });

  @override
  _WaterBottleUpsellPageMobileState createState() =>
      _WaterBottleUpsellPageMobileState();
}

class _WaterBottleUpsellPageMobileState
    extends State<WaterBottleUpsellPageMobile> {
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

  Widget _buildOffer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 15.0,
        right: 25.0,
        left: 25.0,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "50% OFF",
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Theme.of(context).accentColor.withOpacity(1.0),
                    fontSize: 36.0,
                  ),
            ),
            TextSpan(
              text: "\nThe Reusable Dog Water Bottle",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 26.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTrick() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        25.0,
        0.0,
        25.0,
        20.0,
      ),
      alignment: Alignment.center,
      child: Container(
        height: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "Free Shipping Always Included".toUpperCase(),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildWaterBottleCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFE5E5E5),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Container(
              height: 320.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/dog_water_bottle_2x.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            // HORIZONTAL DIVIDER
            Container(
              height: 15.0,
            ),
            OneTimeOfferButton(
              enabled: true,
              text: "Get the Doggo Water Bottle for only \$31.99",
              onPressed: () {
                cart.add(ReusableDogWaterBottle());
                _navigateToNextStep(cart);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeclineText() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                color: Theme.of(context).accentColor.withOpacity(1.0),
                size: 20.0,
              ),
            ],
          ),
        ),
        onTap: () => _navigateToNextStep(cart),
      ),
    );
  }

  Widget _buildSecondOffer() {
    return Column(
      children: [
        Container(
          height: 330.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/dog_water_bottle_2_2x.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            25.0,
            25.0,
            25.0,
            0.0,
          ),
          alignment: Alignment.topLeft,
          child: Text(
            "Don’t Let the Doggo Go Thirsty 💦",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
            25.0,
            15.0,
            25.0,
            0.0,
          ),
          alignment: Alignment.topLeft,
          child: Text(
            "You will never have to carry around a doggy bowl again! We know how inconvenient it can be to lug around both a water bottle & a doggy bowl every single time you go out with your dog.\n\nOur Portable Dog Water Bottle solves this problem! It acts as BOTH the water bowl & the water carrier in an easy to dispense container. Keep your dog healthy & get yours now!",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
          child: OneTimeOfferButton(
            enabled: true,
            text: "Yes! Send a DoggoBox to an Animal Shelter each month",
            onPressed: () {
              cart.add(ReusableDogWaterBottle());
              _navigateToNextStep(cart);
            },
          ),
        ),
      ],
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

  Widget _buildPitchText() {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
      alignment: Alignment.center,
      child: Text(
        "Your Doggo Will Thank You",
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25.0),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        25.0,
        30.0,
        25.0,
        10.0,
      ),
      child: OneTimeOfferButton(
        enabled: true,
        text: "Get the Doggo Water Bottle for only \$31.99",
        onPressed: () {
          cart.add(ReusableDogWaterBottle());
          _navigateToNextStep(cart);
        },
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxWidth: 300.0,
      ),
      padding: EdgeInsets.fromLTRB(
        25.0,
        15.0,
        25.0,
        0.0,
      ),
      child: Image(
        image: AssetImage("assets/badge_2x.png"),
      ),
    );
  }

  void _navigateToNextStep(List<Product> cart) {
    // Purchases everything added to cart
    shoppingCartBloc.onFinishedShopping(widget.user, cart);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return new WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: OrderConfirmationPageMobile(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DoggoAppBar(
        preferredSize: Size.fromHeight(75.0),
        step: 4,
      ),
      body: BlocProvider<ShoppingCartBloc>(
        bloc: shoppingCartBloc,
        child: Container(
          child: ListView(
            padding: EdgeInsets.only(
              top: 0.0,
              bottom: 100.0,
            ),
            children: [
              _buildOffer(),
              _buildSalesTrick(),
              _buildWaterBottleCard(),
              _buildDeclineText(),
              _buildSecondOffer(),
              _buildDeclineText(),
              _buildVideo(),
              _buildButton(),
              _buildPitchText(),
              _buildDeclineText(),
              _buildBadge(),
            ],
          ),
        ),
      ),
    );
  }
}
