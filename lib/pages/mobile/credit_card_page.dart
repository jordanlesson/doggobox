import 'package:doggobox/index.dart';
import 'dart:js' as js;

class CreditCardPageMobile extends StatefulWidget {
  final User user;
  static const String route = '/checkout';
  CreditCardPageMobile({
    @required this.user,
  });

  @override
  _CreditCardPageMobileState createState() => _CreditCardPageMobileState();
}

class _CreditCardPageMobileState extends State<CreditCardPageMobile> {
  CheckOutBloc _checkOutBloc;
  Customer _customer;
  CreditCard _card;
  Address _address;
  js.JsObject paymentRequest;

  @override
  void initState() {
    super.initState();
    // INITIALIZES STRIPE SERVICES
    StripeService.init();
    paymentRequest = js.context.callMethod('createPaymentRequest', []);
    js.context.callMethod('canMakePayment', [paymentRequest]);
    print("Payment Request Object: $paymentRequest");

    _checkOutBloc = CheckOutBloc();

    _customer = Customer();
    _card = CreditCard();
    _address = Address();
  }

  Widget _buildOffer() {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 25.0,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Get the DoggoBox for only ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 35.0,
                fontWeight: FontWeight.w600,
                height: 1.252,
              ),
            ),
            TextSpan(
              text: "\$1",
              style: TextStyle(
                color: Colors.black.withOpacity(0.75),
                fontSize: 40.0,
                fontWeight: FontWeight.w300,
                height: 1.252,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplePayButton(BuildContext context) {
    return FutureBuilder(
      future: promiseToFuture(isApplePayAvailable()),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.data == true) {
          return Container(
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    height: 44.0,
                    constraints: BoxConstraints(
                      minWidth: 200.0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF0A140A),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Check out with",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: "SF Pro",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Container(
                          height: 19.64,
                          width: 46.74,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/apple_pay_3x.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    js.context.callMethod('onApplePayPressed',
                        [widget.user.uid, paymentRequest, _navigateToNextStep]);

                    print("Apple Pay Finished");
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    "OR CHECKOUT WITH A CREDIT CARD",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildCreditCardTextFields() {
    return StreamBuilder<CheckOutResponse>(
        initialData: CheckOutResponse(
          isCardValid: true,
          isCustomerInfoValid: false,
          isValid: false,
        ),
        stream: _checkOutBloc.checkOutStream,
        builder: (context, snapshot) {
          final CheckOutResponse checkOut = snapshot.data;
          return Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Fill In Your Credit Card Details",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CreditCardTextField(
                      onCreditCardChanged: _onCreditCardChanged,
                      error: !checkOut.isCardValid,
                    ),
                  ],
                ),
              ),
              !checkOut.isCardValid
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
                                "Invalid Credit Card",
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
          );
        });
  }

  Widget _buildAddressTextFields() {
    return Container(
      //margin: EdgeInsets.only(bottom: 0.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Zip Code",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "State",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).accentColor.withOpacity(1.0),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      autofillHints: [AutofillHints.postalCode],
                      onChanged: (String postalCode) {
                        _address.postalCode = postalCode;

                        _checkOutBloc.onInfoGiven(_customer, _card, _address);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          right: 20.0,
                          left: 20.0,
                        ),
                        hintText: "93101",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaskedTextInputFormatter(mask: "xxxxx", separator: ""),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                  width: 1.0,
                ),
                Expanded(
                  child: Container(
                    child: TextField(
                      autofillHints: [AutofillHints.addressState],
                      onChanged: (String state) {
                        _address.state = state;
                        _checkOutBloc.onInfoGiven(_customer, _card, _address);
                      },
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          right: 20.0,
                          left: 20.0,
                        ),
                        hintText: "California",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_rounded,
            color: Colors.black.withOpacity(0.4),
            size: 16.0,
          ),
          Container(
            width: 5.0,
          ),
          Text(
            "Your information is secure and encrypted",
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 14.0,
            ),
          ),
        ],
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
        //horizontal: 25.0,
        vertical: 45.0,
      ),
      child: Image(
        image: AssetImage("assets/badge_2x.png"),
      ),
    );
  }

  Widget _buildButton() {
    return BlocProvider(
      bloc: _checkOutBloc,
      child: StreamBuilder<CheckOutResponse>(
        initialData: CheckOutResponse(
          isCardValid: true,
          isCustomerInfoValid: false,
          isValid: false,
        ),
        stream: _checkOutBloc.checkOutStream,
        builder:
            (BuildContext context, AsyncSnapshot<CheckOutResponse> snapshot) {
          final CheckOutResponse checkOut = snapshot.data;
          return StreamBuilder<FirestoreResponse>(
            initialData:
                FirestoreResponse(message: "initialized", success: false),
            stream: _checkOutBloc.transactionStream,
            builder: (BuildContext context,
                AsyncSnapshot<FirestoreResponse> transactionSnapshot) {
              final FirestoreResponse response = transactionSnapshot.data;
              print(response.message);
              return DoggoButton(
                enabled: response.message != "loading",
                text: "⚡️Claim Your DoggoBox Now⚡️",
                onPressed: () => _checkOutBloc.onDoggoBoxPurchased(
                    context, widget.user, _customer, _card, _address),
              );
            },
          );
        },
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
              mobilePage: OneTimeOfferPageMobile(
                user: widget.user,
              ),
              desktopPage: OneTimeOfferPageDesktop(
                user: widget.user,
              ),
            ),
          );
        },
      ),
    );
  }

  void _onCreditCardChanged(CreditCard card) {
    _card.number = card.number;
    _card.expMonth = card.expMonth;
    _card.expYear = card.expYear;
    _card.cvc = card.cvc;

    _checkOutBloc.onInfoGiven(_customer, _card, _address);
  }

  void _onNameChanged(String name) {
    _customer.name = name;
    _checkOutBloc.onInfoGiven(
      _customer,
      _card,
      _address,
    );
  }

  void _onStreetAddressChanged(String line1) {
    _address.line1 = line1;
    _checkOutBloc.onInfoGiven(_customer, _card, _address);
  }

  void _onCityChanged(String city) {
    _address.city = city;
    _checkOutBloc.onInfoGiven(_customer, _card, _address);
  }

  void _onCountryChanged(String country) {
    _address.country = country;
    _checkOutBloc.onInfoGiven(_customer, _card, _address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DoggoAppBar(
        preferredSize: Size.fromHeight(75.0),
        desktop: false,
        step: 2,
      ),
      body: Container(
        child: AutofillGroup(
          child: ListView(
            padding: EdgeInsets.only(
              top: 0.0,
              bottom: 100.0,
              right: 25.0,
              left: 25.0,
            ),
            children: [
              _buildOffer(),
              _buildApplePayButton(context),
              _buildCreditCardTextFields(),
              InfoTextField(
                label: "Full Name",
                hintText: "Simba Doggo",
                keyboardType: TextInputType.name,
                onChanged: _onNameChanged,
                autofillHints: [AutofillHints.name],
              ),
              InfoTextField(
                label: "Address",
                hintText: "150 Berry St. Apt 23",
                keyboardType: TextInputType.streetAddress,
                onChanged: _onStreetAddressChanged,
                autofillHints: [AutofillHints.fullStreetAddress],
              ),
              InfoTextField(
                label: "City",
                hintText: "San Francisco",
                onChanged: _onCityChanged,
                autofillHints: [AutofillHints.addressCity],
              ),
              _buildAddressTextFields(),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: InfoTextField(
                  label: "Country",
                  hintText: "United States",
                  onChanged: _onCountryChanged,
                  autofillHints: [AutofillHints.countryName],
                ),
              ),
              _buildButton(),
              _buildSecurityNote(),
              _buildBadge(),
            ],
          ),
        ),
      ),
    );
  }
}
