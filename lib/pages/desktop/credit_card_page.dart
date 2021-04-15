import 'package:doggobox/index.dart';
import 'dart:js' as js;

class CreditCardPageDesktop extends StatefulWidget {
  final User user;

  CreditCardPageDesktop({
    @required this.user,
  });

  @override
  _CreditCardPageDesktopState createState() => _CreditCardPageDesktopState();
}

class _CreditCardPageDesktopState extends State<CreditCardPageDesktop> {
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

  Widget _buildStepCounter() {
    return Container(
      padding: EdgeInsets.only(
        top: 20.0,
      ),
      alignment: Alignment.topLeft,
      child: Text(
        "Step 2 of 4",
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
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Get the DoggoBox\nfor only ",
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
    );
  }

  Widget _buildPromotionalImage() {
    return Container(
      //height: 593.0,
      //color: Colors.green,
      constraints: BoxConstraints(maxWidth: 500.0),
      alignment: Alignment.topCenter,
      child: Image(
        image: AssetImage(
          "assets/doggo_box_contents_3x.png",
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      alignment: Alignment.centerLeft,
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
          alignment: Alignment.topCenter,
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
                ? Container(
                    //color: Colors.green,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 10.0),
                    child: ErrorAlert(errorText: "Invalid Credit Card"),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buildFullNameTextField() {
    return StreamBuilder<CheckOutResponse>(
      initialData: CheckOutResponse(
        isCardValid: true,
        isCustomerInfoValid: true,
        isValid: false,
      ),
      stream: _checkOutBloc.checkOutStream,
      builder:
          (BuildContext context, AsyncSnapshot<CheckOutResponse> snapshot) {
        CheckOutResponse checkOut = snapshot.data;
        return Stack(
          children: [
            InfoTextField(
              label: "Full Name",
              hintText: "Simba Doggo",
              keyboardType: TextInputType.name,
              onChanged: _onNameChanged,
              autofillHints: [AutofillHints.name],
            ),
            !checkOut.isCustomerInfoValid
                ? Container(
                    //color: Colors.green,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 25.0),
                    child: ErrorAlert(errorText: "Incomplete Address"),
                  )
                : Container(),
          ],
        );
      },
    );
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
                text: response.message != "loading"
                    ? "⚡️Claim Your DoggoBox Now⚡️"
                    : "Claiming DoggoBox...",
                loading: response.message == "loading",
                onPressed: () => _checkOutBloc.onDoggoBoxPurchased(
                    context, widget.user, _customer, _card, _address),
              );
            },
          );
        },
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
            size: 18.0,
          ),
          Container(
            width: 5.0,
          ),
          Text(
            "Your information is secure and encrypted",
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 18.0,
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
        preferredSize: Size.fromHeight(100.0),
        desktop: true,
        step: 2,
      ),
      body: Container(
        //color: Colors.green,
        child: AutofillGroup(
          child: ListView(
            padding: EdgeInsets.only(
              top: 0.0,
              bottom: 100.0,
              right: 56.0,
              left: 56.0,
            ),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepCounter(),
                        _buildOffer(),
                        _buildPromotionalImage(),
                        _buildBadge(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      //color: Colors.pink,
                      padding: EdgeInsets.symmetric(
                        horizontal: 100.0,
                        vertical: 50.0,
                      ),
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _buildApplePayButton(context),
                          _buildCreditCardTextFields(),
                          _buildFullNameTextField(),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
