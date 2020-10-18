import 'package:doggobox/index.dart';

class AnimalShelterUpsellPageDesktop extends StatefulWidget {
  final List<Product> cart;
  final User user;

  AnimalShelterUpsellPageDesktop({
    @required this.cart,
    @required this.user,
  });

  @override
  _AnimalShelterUpsellPageDesktopState createState() =>
      _AnimalShelterUpsellPageDesktopState();
}

class _AnimalShelterUpsellPageDesktopState
    extends State<AnimalShelterUpsellPageDesktop> {
  List<Product> cart;

  @override
  void initState() {
    super.initState();
    cart = List<Product>.from(widget.cart);
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
        "Help Support Dogs in Animal Shelters",
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
      //padding: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.centerLeft,
      child: Container(
        height: 35.0,
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: 576.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFDEF2),
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

  Widget _buildQuestion() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        constraints: BoxConstraints(
          maxWidth: 735.0,
        ),
        child: Text(
          "Would you Like to Send a DoggoBox to an Animal Shelter Each Month?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 35.0,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
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
              top: 25.0,
              right: 20.0,
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
              desktop: true,
              onButtonPressed: () {
                cart.add(AnimalShelterDoggoBox());
                _navigateToNextStep();
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 150.0,
              width: 150.0,
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

  Widget _buildMissionStatement() {
    return Container(
      padding: EdgeInsets.only(left: 56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "The Doggo Mission ❤️",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontSize: 35.0),
            ),
          ),
          Container(
            child: Text(
              "Animal shelters do the hard work associated with caring for stray doggos. The shelters play a vital role in our communities as they continuously work to reunite pets with their owners, shelter those in need and find new homes for animals that are lost or without a permanent home.\n\nWe believe that it is our mission to support the shelters because they provide and care for animals in need.",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 18.0),
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

  Widget _buildDeclineText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
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
          _buildQuestion(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOneTimeOffer(),
              ),
              Expanded(
                child: _buildMissionStatement(),
              ),
            ],
          ),
          _buildDeclineText(),
        ],
      ),
    );
  }
}
