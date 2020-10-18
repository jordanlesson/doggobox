import 'package:doggobox/index.dart';

class AnimalShelterUpsellPageMobile extends StatefulWidget {
  final List<Product> cart;
  final User user;

  AnimalShelterUpsellPageMobile({
    @required this.cart,
    @required this.user,
  });

  @override
  _AnimalShelterUpsellPageMobileState createState() =>
      _AnimalShelterUpsellPageMobileState();
}

class _AnimalShelterUpsellPageMobileState
    extends State<AnimalShelterUpsellPageMobile> {
  List<Product> cart;

  @override
  void initState() {
    super.initState();
    cart = List<Product>.from(widget.cart);
  }

  Widget _buildOffer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 25.0,
        right: 25.0,
        left: 25.0,
      ),
      child: Text(
        "Help Support Dogs in Animal Shelters",
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 26.0),
      ),
    );
  }

  Widget _buildSalesTrick() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.0,
        right: 25.0,
        left: 25.0,
      ),
      alignment: Alignment.center,
      child: Container(
        height: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFFFDEF2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "You Can Help Save Animals Today".toUpperCase(),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 10.0,
        right: 25.0,
        left: 25.0,
      ),
      child: Text(
        "Would you like to Send a DoggoBox to an Animal Shelter each month?",
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18.0),
      ),
    );
  }

  Widget _buildOneTimeOffer() {
    return Container(
      padding: EdgeInsets.only(
        right: 5.0,
        left: 10.0,
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 10.0,
              right: 5.0,
            ),
            child: OneTimeOfferCell(
              imagePath: "assets/sample_dog_banner_3_2x.png",
              title: "Send a DoggoBox to an Animal Shelter",
              subtitle:
                  "Food, treats and toys for our the doggos that need it most.",
              details:
                  "Add this box to your order for only \$19.99 a month and we will send food, treats and toys for our the doggos that need it most every month.",
              buttonText:
                  "Yes! Send a DoggoBox to an Animal Shelter each month ",
              desktop: false,
              onButtonPressed: () {
                cart.add(AnimalShelterDoggoBox());
                _navigateToNextStep();
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/stamp_3x.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclineText() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
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
                  fontSize: 14.0,
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
        onTap: _navigateToNextStep,
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxWidth: 300.0,
      ),
      padding: EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        bottom: 35.0,
      ),
      child: Image(
        image: AssetImage("assets/badge_2x.png"),
      ),
    );
  }

  Widget _buildSecondOffer() {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/dog_napping_2x.png"),
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
                  "The Doggo Mission ❤️",
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
                  "Animal shelters do the hard work associated with caring for stray doggos. The shelters play a vital role in our communities as they continuously work to reunite pets with their owners, shelter those in need and find new homes for animals that are lost or without a permanent home.\n\nWe believe that it is our mission to support the shelters because they provide and care for animals in need",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                child: OneTimeOfferButton(
                  enabled: true,
                  text: "Yes! Send a DoggoBox to an Animal Shelter each month",
                  onPressed: () {
                    cart.add(AnimalShelterDoggoBox());
                    _navigateToNextStep();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  25.0,
                  0.0,
                  25.0,
                  0.0,
                ),
                child: Text(
                  "Add this box to your order for only \$19.99 a month and we will send food, treats and toys for the doggos that need it most every month.",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Color(0xFF999999),
                        fontSize: 10.0,
                      ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 185.0,
            right: 10.0,
            child: Container(
              height: 130.0,
              width: 130.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/stamp_2x.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextStep() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: ViewController(
              mobilePage: WaterBottleUpsellPageMobile(
                cart: cart,
                user: widget.user,
              ),
              desktopPage: WaterBottleUpsellPageDesktop(
                cart: cart,
                user: widget.user,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingCartBloc shoppingCartBloc =
        BlocProvider.of<ShoppingCartBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DoggoAppBar(
        desktop: false,
        preferredSize: Size.fromHeight(75.0),
        step: 3,
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
              _buildTitle(),
              _buildOneTimeOffer(),
              _buildDeclineText(),
              _buildBadge(),
              _buildSecondOffer(),
              _buildDeclineText(),
            ],
          ),
        ),
      ),
    );
  }
}
