import 'package:doggobox/index.dart';

class OneTimeOfferPageMobile extends StatefulWidget {
  final User user;

  OneTimeOfferPageMobile({
    @required this.user,
  });

  @override
  _OneTimeOfferPageMobileState createState() => _OneTimeOfferPageMobileState();
}

class _OneTimeOfferPageMobileState extends State<OneTimeOfferPageMobile> {
  List<Product> cart;

  @override
  void initState() {
    super.initState();
    cart = List<Product>();
  }

  Widget _buildOffer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        left: 15.0,
        right: 15.0,
        bottom: 25.0,
      ),
      child: Text(
        "Get the DoggoBox Tailored for your dog's size each month",
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 26.0),
      ),
    );
  }

  Widget _buildSalesTrick() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.0,
        left: 15.0,
        right: 15.0,
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

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 10.0,
        right: 20.0,
        left: 20.0,
      ),
      child: Text(
        "How Big is Your Doggo?",
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 26.0),
      ),
    );
  }

  Widget _buildDeclineText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          child: Text(
            "No, I do not want this great offer",
            style: TextStyle(
              color: Theme.of(context).accentColor.withOpacity(1.0),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
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
      child: Image(
        image: AssetImage("assets/badge_2x.png"),
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
              mobilePage: AnimalShelterUpsellPageMobile(
                cart: cart,
                user: widget.user,
              ),
              desktopPage: AnimalShelterUpsellPageMobile(
                cart: cart,
                user: widget.user,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmallBoxButton() {
    return OneTimeOfferCell(
      imagePath: "assets/sample_dog_banner_1_2x.png",
      title: "Small and Cute DoggoBox",
      subtitle: "For Doggos up to 40 Lbs",
      details:
          "Get the small, squishy, fluffy toy best suited for small doggos with little chompers and chewers every month. Not to mention the cutest little toys like tiny fruit themed toys. These are pawfect for little puppers and Doggos that don't need the big doggo chews. Add this box to your order for only \$29.99 a month. We will ship it to you with FREE SHIPPING. Not to mention you get only the best toys for your little doggo!",
      buttonText: "Yes! Continue to get the Small DoggoBox each month ",
      desktop: false,
      onButtonPressed: () {
        cart.add(SmallDoggoBox());
        _navigateToNextStep();
      },
    );
  }

  Widget _buildBigBoxButton() {
    return OneTimeOfferCell(
      imagePath: "assets/sample_dog_banner_2_2x.png",
      title: "BIG and BOLD DoggoBox",
      subtitle: "For Doggos 40 Lbs and up!",
      details:
          "Get the harder, stronger, toys designed by us and tested by our dogs to stand up to the toughest chewers. Made with strong rubber and nylon, these toys were made for chompin’.. Each is part of a themed collection of super-tough toys,. These are pawfect for big puppers and Doggos! This DoggoBox is best suited for larger doggos with bigger chompers and chewers delivered to you every month. Add this box to your order for only \$29.99 a month. We will ship it to you with FREE SHIPPING. Not to mention you get only the best toys for your little doggo!",
      buttonText: "Yes! Continue to get the Big DoggoBox each month ",
      desktop: false,
      onButtonPressed: () {
        cart.add(BigDoggoBox());
        _navigateToNextStep();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DoggoAppBar(
        desktop: false,
        preferredSize: Size.fromHeight(75.0),
        step: 3,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(
            top: 0.0,
            bottom: 100.0,
            right: 10.0,
            left: 10.0,
          ),
          children: [
            _buildOffer(),
            _buildSalesTrick(),
            _buildTitle(),
            _buildSmallBoxButton(),
            // VERTICAL DIVIDER
            Container(
              height: 20.0,
            ),
            _buildBigBoxButton(),
            _buildDeclineText(),
            _buildBadge(),
          ],
        ),
      ),
    );
  }
}
