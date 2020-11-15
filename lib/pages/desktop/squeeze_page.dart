import 'package:doggobox/index.dart';

class SqueezePageDesktop extends StatefulWidget {
  @override
  _SqueezePageDesktopState createState() => _SqueezePageDesktopState();
}

class _SqueezePageDesktopState extends State<SqueezePageDesktop> {
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
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      //color: Colors.blue,
      child: Container(
        height: 75.0,
        width: 201.0,
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
      //color: Colors.red,
      padding: EdgeInsets.only(
        top: 50.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Get the DoggoBox for only ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 55.0,
                    fontWeight: FontWeight.w600,
                    height: 1.252,
                  ),
                ),
                TextSpan(
                  text: "\$1",
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 40.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "A totally customized box of themed toys and goodies for your Doggo 🐶",
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTextField() {
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
              constraints: BoxConstraints(maxWidth: 440.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "What's your best email? ✉️",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        constraints: BoxConstraints(
                          maxWidth: 440.0,
                        ),
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
                            errorText: emailSnapshot.data.error ? "" : null,
                            errorStyle: TextStyle(height: 0.0),
                            suffixIcon: emailSnapshot.data.error
                                ? Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  )
                                : Container(
                                    height: 0.0,
                                    width: 0.0,
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
                                  margin: EdgeInsets.only(top: 15.0),
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
                                    style: Theme.of(context).textTheme.overline,
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
        },
      ),
    );
  }

  Widget _buildPromotionalImages() {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.only(top: 60.0),
      height: 644.0,
      width: 757.0,
      alignment: Alignment.bottomRight,
      child: Image(
        image: AssetImage("assets/dog_and_box_desktop_2x.png"),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      alignment: Alignment.centerRight,
      //color: Colors.green,
      constraints: BoxConstraints(
        maxWidth: 432.0,
      ),
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: Image(
        image: AssetImage("assets/badge_desktop_2x.png"),
      ),
    );
  }

  Widget _buildGuarantee() {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/dog_chewing_toy_2x.png"),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 25.0),
                    //constraints: BoxConstraints(maxWidth: 350.0),
                    child: Text(
                      "Only the Best for Your Pupper! ❤️",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    //constraints: BoxConstraints(maxWidth: 350.0),
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: Text(
                      "If your dog isn't 100% happy with their DoggoBox, we'll work with you to make it right no muss, no fuss, no disappointed pups. Plus it's actually only \$1",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(
                    // horizontal: 25.0,
                    // vertical: 15.0,
                    // ),
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
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(1.0),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              child: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(1.0),
                                size: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: focusEmailTextField,
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

  Widget _buildBoxDetails() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 75.0,
      ),
      //color: Colors.yellow,
      //constraints: BoxConstraints(maxWidth: 350.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //padding: EdgeInsets.only(top: 20.0),
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
                      style: TextStyle(
                        height: 1.75,
                      ),
                      children: [
                        TextSpan(
                          text: "The most ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                        TextSpan(
                          text: "squishy, squeaky, floofy ",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "toys for your Doggo (worth over ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                        TextSpan(
                          text: "\$40",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: ")\n\nSuitable for ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                        TextSpan(
                          text: "all dog breeds ",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              "as a company we get the very best wholesale price, which means we can pass these savings on to you, our customers. Each box has a retail value of \$40+ but the DoggoBox are ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                        TextSpan(
                          text: "only \$1 right now.\n\n",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "Every DoggoBox has a bunch of ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                        TextSpan(
                          text: "innovative toys",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              ", curated from each month's themed collection.\n\nReady to spoil your pup with a ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                        TextSpan(
                          text: "DoggoBox ",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "of their very own!?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20.0,
                15.0,
                0.0,
                15.0,
              ),
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/doggo_box_contents_3x.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 135.0,
        vertical: 75.0,
      ),
      constraints: BoxConstraints(maxWidth: 350.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "Don't Take It From Us - See What They Are Barking About",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Testimonial(
                  imagePath: "assets/sample_dog_1_2x.png",
                  review:
                      "Thank you so much for the box... it looked fab from the packaging to the contents... My girl also loved the toys!!!",
                  name: "Aaron S.",
                ),
              ),
              Expanded(
                child: Testimonial(
                  imagePath: "assets/sample_dog_2_2x.png",
                  review:
                      "We got our box today and the dogs went wild!! I buy loads of toys but these were on a  different level, I've never seen them go so made bfore!! I look forward to getting the next one!",
                  name: "Rachel B.",
                ),
              ),
              Expanded(
                child: Testimonial(
                  imagePath: "assets/sample_dog_3_2x.png",
                  review:
                      "I am very impressed with the first box. So glad we joined. Well done keep up the good work!",
                  name: "Jennifer P.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffer2() {
    return Container(
      //color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/dog_party_2x.png"),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 25.0),
                    //constraints: BoxConstraints(maxWidth: 350.0),
                    child: Text(
                      "Join The Party Before It's Over!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 25.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          height: 1.75,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Ready to spoil your Doggo with a DoggoBox of their very own!?\n\n",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          TextSpan(
                            text:
                                "You get a bunch of handpicked Doggo products uniquely bundled together\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 18.0),
                          ),
                          TextSpan(
                            text:
                                "Tug, toss, and chew your heart out. BPA-free and tested to meet food-safe standards.\n\n",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 18.0),
                          ),
                          TextSpan(
                            text:
                                "If your dog isn't 100% happy with their DoggoBox, we’ll work with you to make it right. No muss, no fuss, no disappointed pups.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(
                    // horizontal: 25.0,
                    // vertical: 15.0,
                    // ),
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
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(1.0),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              child: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(1.0),
                                size: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: focusEmailTextField,
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

  void focusEmailTextField() async {
    FocusManager.instance.primaryFocus.unfocus();
    await scrollController.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
    emailFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AnnouncementBar(
        announcement: "GET YOUR FIRST DOGGOBOX FOR \$1 & FREE SHIPPING",
        desktop: true,
        preferredSize: Size.fromHeight(35.0),
      ),
      body: Container(
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.only(
            top: 0.0,
            bottom: 130.0,
          ),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 56.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLogo(),
                        _buildOffer(),
                        _buildEmailTextField(),
                      ],
                    ),
                  ),
                  // RIGHT SIDE
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildPromotionalImages(),
                          _buildBadge(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildGuarantee(),
            _buildBoxDetails(),
            _buildTestimonials(),
            _buildOffer2(),
          ],
        ),
      ),
    );
  }
}
