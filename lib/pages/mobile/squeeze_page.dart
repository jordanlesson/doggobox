import 'package:doggobox/index.dart';

class SqueezePageMobile extends StatefulWidget {
  static const String route = '/';
  @override
  _SqueezePageMobileState createState() => _SqueezePageMobileState();
}

class _SqueezePageMobileState extends State<SqueezePageMobile> {
  EmailBloc emailBloc;
  TextEditingController emailController;
  FocusNode emailFocusNode;
  ScrollController scrollController;
  String _email;

  @override
  void initState() {
    super.initState();
    _email = "";
    emailBloc = EmailBloc();
    emailController = TextEditingController();
    emailFocusNode = FocusNode();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    emailBloc.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    scrollController.dispose();
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
                  text: "\$1",
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

  Widget _buildEmailField() {
    return BlocProvider(
      bloc: emailBloc,
      child: StreamBuilder<EmailResponse>(
          stream: emailBloc.emailStream,
          initialData: EmailResponse(
            user: null,
            success: false,
            error: false,
            isLoading: false,
          ),
          builder: (context, emailSnapshot) {
            return AutofillGroup(
              child: Container(
                constraints: BoxConstraints(maxWidth: 300.0),
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "What's your best email? ✉️",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            controller: emailController,
                            autofillHints: [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            focusNode: emailFocusNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(1.0),
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(1.0),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(1.0),
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).errorColor,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).errorColor,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 25.0,
                                top: 24.0,
                                bottom: 22.5,
                                right: 25.0,
                              ),
                              hintText: "simba@thedoggobox.com",
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                              errorText: emailSnapshot.data.error ? "" : null,
                              errorStyle: TextStyle(height: 0.0),
                              suffixIcon: emailSnapshot.data.error
                                  ? Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    )
                                  : null,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            onChanged: (String input) {
                              emailBloc.checkEmail(input.toLowerCase().trim());
                              _email = input.toLowerCase().trim();
                            },
                          ),
                        ),
                        DoggoButton(
                          text: "⚡️Claim Your DoggoBox Now⚡️",
                          enabled: !emailSnapshot.data.isLoading,
                          onPressed: () => _email.isNotEmpty
                              ? emailBloc.onDoggoBoxClaimed(
                                  context, _email.toLowerCase().trim())
                              : null,
                        ),
                      ],
                    ),
                    emailSnapshot.data.error
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).errorColor,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: Text(
                                      "Invalid Email",
                                      style:
                                          Theme.of(context).textTheme.overline,
                                    ),
                                  ),
                                ),
                                CustomPaint(
                                  painter: TrianglePainter(
                                    strokeColor: Theme.of(context).errorColor,
                                    paintingStyle: PaintingStyle.fill,
                                  ),
                                  child: Container(
                                    height: 6.0,
                                    width: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }),
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
        vertical: 55.0,
      ),
      child: Image(
        image: AssetImage("assets/badge_2x.png"),
      ),
    );
  }

  Widget _buildGuarantee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        // padding: EdgeInsets.symmetric(horizontal: 25.0),
        // constraints: BoxConstraints(maxWidth: 350.0),
        //   child: Text(
        //     "Only the Best for Your Pupper! ❤️",
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 18.0,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          constraints: BoxConstraints(maxWidth: 350.0),
          child: Text(
            "Only the Best for Your Pupper! ❤️",
            style: Theme.of(context).textTheme.headline1,
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
            "If your dog isn't 100% happy with their DoggoBox, we'll work with you to make it right no muss, no fuss, no disappointed pups. Plus it's actually only \$1",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          height: 25.0,
        ),
      ],
    );
  }

  Widget _buildBoxDetails() {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 30.0),
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
                    text: "squishy, squeaky, floofy toys ",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: "for your Doggo (worth over ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "\$40",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: ")\n\nTons of 100% ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "Natural Tasty Treats ",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: "for your Doggo \n\n",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "Suitable for ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "all dog breeds ",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text:
                        "\n\nEach box has a retail value of \$40+ but a DoggoBox are ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "only \$1 right now.\n\n",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: "Every DoggoBox has a bunch of ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(
                    text: "innovative toys",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: ", curated from each month's themed collection.",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: DoggoBoxClaimButton(
              text: "Claim Your DoggoBox Now",
              onPressed: focusEmailTextField,
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
            child: DoggoBoxClaimButton(
              text: "Claim Your DoggoBox Now",
              onPressed: focusEmailTextField,
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
                      "You get a bunch of handpicked Doggo products uniquely bundled together\n\nTug, toss, and chew your heart out. BPA-free and tested to meet food-safe standards.\n\nIf your dog isn't 100% happy with their DoggoBox, we'll work with you to make it right. No muss, no fuss, no disappointed pups",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          alignment: Alignment.centerLeft,
          child: DoggoBoxClaimButton(
            text: "Claim Your DoggoBox Now",
            onPressed: focusEmailTextField,
          ),
        ),
      ],
    );
  }

  void focusEmailTextField() async {
    FocusManager.instance.primaryFocus.unfocus();
    await scrollController.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    emailFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AnnouncementBar(
          announcement: "GET YOUR FIRST DOGGOBOX FOR \$1 & FREE SHIPPING",
          desktop: false,
          preferredSize: Size.fromHeight(35.0),
        ),
        body: ListView(
          controller: scrollController,
          padding: EdgeInsets.only(
            top: 0.0,
          ),
          children: [
            _buildLogo(),
            _buildOffer(),
            _buildEmailField(),
            _buildBoxDetails(),
            _buildGuarantee(),
            _buildTestimonials(),
            _buildOffer2(),
            _buildBadge(),
            Footer(),
          ],
        ),
      ),
      onTap: () => emailFocusNode.unfocus(),
    );
  }
}
