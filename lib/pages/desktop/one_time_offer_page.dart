import 'package:doggobox/index.dart';

class OneTimeOfferPageDesktop extends StatefulWidget {
  final User user;

  OneTimeOfferPageDesktop({
    @required this.user,
  });

  @override
  _OneTimeOfferPageDesktopState createState() =>
      _OneTimeOfferPageDesktopState();
}

class _OneTimeOfferPageDesktopState extends State<OneTimeOfferPageDesktop> {
  List<Product> cart;

  @override
  void initState() {
    super.initState();
    cart = List<Product>();
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
      child: Text(
        "Get the DoggoBox Tailored for your\nDog's Size Each Month",
        style: TextStyle(
          color: Colors.black,
          fontSize: 48.0,
          fontWeight: FontWeight.w600,
          height: 1.252,
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
          "Free Shipping Always Included".toUpperCase(),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(
        "How Big is your Doggo?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 48.0,
          fontWeight: FontWeight.w600,
          height: 1.252,
        ),
      ),
    );
  }

  Widget _buildDoggoBoxSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        height: 669.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: OneTimeOfferCell(
                imagePath: "assets/sample_dog_banner_1_2x.png",
                title: "Small and Cute DoggoBox",
                subtitle: "For Doggos up to 40 Lbs",
                details:
                    "Get the small, squishy, fluffy toy best suited for small doggos with little chompers and chewers every month. Not to mention the cutest little toys like tiny fruit themed toys. These are pawfect for little puppers and Doggos that don't need the big doggo chews. Add this box to your order for only \$29.99 a month. We will ship it to you with FREE SHIPPING. Not to mention you get only the best toys for your little doggo!",
                buttonText:
                    "Yes! Continue to get the Small DoggoBox each month ",
                desktop: true,
                onButtonPressed: () {
                  cart.add(SmallDoggoBox());
                  _navigateToNextStep();
                },
              ),
            ),
            // DIVIDER
            Container(
              width: 20.0,
            ),
            Expanded(
              child: OneTimeOfferCell(
                imagePath: "assets/sample_dog_banner_2_2x.png",
                title: "BIG and BOLD DoggoBox",
                subtitle: "For Doggos 40 Lbs and up!",
                details:
                    "Get the harder, stronger, toys designed by us and tested by our dogs to stand up to the toughest chewers. Made with strong rubber and nylon, these toys were made for chompin’.. Each is part of a themed collection of super-tough toys,. These are pawfect for big puppers and Doggos! This DoggoBox is best suited for larger doggos with bigger chompers and chewers delivered to you every month. Add this box to your order for only \$29.99 a month. We will ship it to you with FREE SHIPPING. Not to mention you get only the best toys for your little doggo!",
                buttonText: "Yes! Continue to get the Big DoggoBox each month ",
                desktop: true,
                onButtonPressed: () {
                  cart.add(BigDoggoBox());
                  _navigateToNextStep();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeclineText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
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
        onTap: _navigateToNextStep,
      ),
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
        padding: EdgeInsets.symmetric(vertical: 25.0),
        child: Image(
          image: AssetImage("assets/badge_desktop_2x.png"),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DoggoAppBar(
        preferredSize: Size.fromHeight(100.0),
        desktop: true,
        step: 3,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 56.0),
        children: [
          _buildStepCounter(),
          _buildOffer(),
          _buildSalesTrick(),
          _buildQuestion(),
          _buildDoggoBoxSelection(),
          _buildDeclineText(),
          _buildBadge(),
        ],
      ),
    );
  }
}
