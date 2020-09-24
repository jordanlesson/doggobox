import 'package:doggobox/index.dart';

class SqueezePageMobile extends StatefulWidget {
  @override
  _SqueezePageMobileState createState() => _SqueezePageMobileState();
}

class _SqueezePageMobileState extends State<SqueezePageMobile> {
  EmailBloc emailBloc;
  FocusNode emailFocusNode;
  String _email;

  @override
  void initState() {
    super.initState();
    emailBloc = EmailBloc();
    emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailBloc.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        height: 39.0,
        width: 105.23,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/doggo_shop_logo_2x.png",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffer() {
    return Container(
      constraints: BoxConstraints(maxWidth: 350.0),
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Get the DoggoBox for only ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                      height: 1.252),
                ),
                TextSpan(
                  text: "\$5",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 35.0,
                    fontWeight: FontWeight.w300,
                    height: 1.252,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            alignment: Alignment.center,
            child: Text(
              "A totally customized box of themed toys and goodies for your Doggo 🐶",
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assets/dog_and_box_3x.png"),
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
          return new WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: CreditCardPage(
              email: _email,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return BlocProvider(
      bloc: emailBloc,
      child: AutofillGroup(
        child: Container(
          constraints: BoxConstraints(maxWidth: 300.0),
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "What's your best email? ✉️",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: TextField(
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  focusNode: emailFocusNode,
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
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (String input) {
                    emailBloc.checkEmail(input.toLowerCase());
                    _email = input;
                  },
                ),
              ),
              StreamBuilder<bool>(
                stream: emailBloc.emailStream,
                initialData: false,
                builder: (context, emailSnapshot) {
                  final bool enabled = emailSnapshot.data;
                  return DoggoButton(
                    text: "⚡️Claim Your DoggoBox Now⚡️",
                    enabled: enabled,
                    onPressed: _navigateToNextStep,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxWidth: 300.0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 45.0,
      ),
      child: Image(
        image: AssetImage("assets/badge_2x.png"),
      ),
    );
  }

  Widget _buildGuarantee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          constraints: BoxConstraints(maxWidth: 350.0),
          child: Text(
            "Only the Best for Your Pupper! ❤️",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15.0),
          alignment: Alignment.center,
          child: Image(
            image: AssetImage("assets/dog_chewing_toy_2x.png"),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 350.0),
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            "If your dog isn't 100% happy with their DoggoBox, we'll work with you to make it right no muss, no fuss, no disappointed pups. Plus it's actually only \$5",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 15.0,
          ),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Claim Your DoggoBox Now",
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(1.0),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).accentColor.withOpacity(1.0),
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => FocusScope.of(context).requestFocus(emailFocusNode),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxDetails() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 15.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assets/doggo_box_contents_2x.png"),
            ),
          ),
          Container(
            child: Text(
              "What's inside the Box?",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "The most ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "squishy, squeaky, floofy ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: "toys for your Doggo (worth over ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "\$40",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ")\n\nSuitable for ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "all dog breeds ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text:
                        "as a company we get the very best wholesale price, which means we can pass these savings on to you, our customers. Each box has a retail value of \$40+ but the DoggoBox are ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "only \$5 right now.\n\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: "Every DoggoBox has a bunch of ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "innovative toys",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text:
                        ", curated from each month's themed collection.\n\nReady to spoil your pup with a ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "DoggoBox ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: "of their very own!?",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Claim Your DoggoBox Now",
                      style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      child: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        size: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => FocusScope.of(context).requestFocus(emailFocusNode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 15.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: Column(
        children: [
          Container(
            child: Text(
              "Don't Take It From Us - See What They Are Barking About",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Testimonial(
            imagePath: "assets/sample_dog_1_2x.png",
            review:
                "Thank you so much for the box... it looked fab from the packaging to the contents... My girl also loved the toys!!!",
            name: "Aaron S.",
          ),
          Testimonial(
            imagePath: "assets/sample_dog_2_2x.png",
            review:
                "We got our box today and the dogs went wild!! I buy loads of toys but these were on a  different level, I've never seen them go so made bfore!! I look forward to getting the next one!",
            name: "Rachel B.",
          ),
          Testimonial(
            imagePath: "assets/sample_dog_3_2x.png",
            review:
                "I am very impressed with the first box. So glad we joined. Well done keep up the good work!",
            name: "Jennifer P.",
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Claim Your DoggoBox Now",
                      style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      child: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).accentColor.withOpacity(1.0),
                        size: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => FocusScope.of(context).requestFocus(emailFocusNode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffer2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 25.0),
          alignment: Alignment.center,
          child: Image(
            image: AssetImage("assets/dog_party_2x.png"),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            "Join the Party before it's over",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 350.0),
          margin: EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 15.0,
          ),
          alignment: Alignment.topLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Ready to spoil your Doggo with a DoggoBox of their very own!?\n\n",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      "You get a bunch of handpicked Doggo products uniquely bundled together\n\nTug, toss, and chew your heart out. BPA=free and tested to meet food-safe standards.\n\nIf your dog isn't 100% happy with their DoggoBox, we'll work with you to make it right. No muss, no fuss, no disappointed pups",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Claim Your DoggoBox Now",
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(1.0),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).accentColor.withOpacity(1.0),
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => FocusScope.of(context).requestFocus(emailFocusNode),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AnnouncementBar(
          announcement: "GET YOUR FIRST DOGGOBOX FOR \$5 & FREE SHIPPING",
          desktop: false,
          preferredSize: Size.fromHeight(35.0),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            top: 0.0,
            bottom: 100.0,
          ),
          children: [
            _buildLogo(),
            _buildOffer(),
            _buildEmailField(),
            _buildBadge(),
            _buildGuarantee(),
            _buildBoxDetails(),
            _buildTestimonials(),
            _buildOffer2(),
          ],
        ),
      ),
      onTap: () => emailFocusNode.unfocus(),
    );
  }
}
