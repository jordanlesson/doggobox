import 'package:doggobox/index.dart';
import 'dart:js' as js;

class CreditCardPage extends StatefulWidget {
  final String email;

  CreditCardPage({
    @required this.email,
  });

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  CheckOutBloc _checkOutBloc;
  Customer _customer;
  CreditCard _card;
  Address _address;

  @override
  void initState() {
    super.initState();
    // INITIALIZES STRIPE SERVICES
    StripeService.init();

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
              text: "\$5",
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

  Widget _buildApplePayButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        child: Container(
          height: 40.0,
          constraints: BoxConstraints(
            minWidth: 200.0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Check out with",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "SF Pro",
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.emoji_food_beverage,
                color: Colors.white,
              ),
            ],
          ),
        ),
        onTap: () => js.context.callMethod("payWithApplePay", []),
      ),
    );
  }

  Widget _buildCreditCardTextFields() {
    return Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTextFields() {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
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
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _checkOutBloc.checkOutStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          final bool formIsValid = snapshot.data;
          return StreamBuilder<FirestoreResponse>(
            initialData:
                FirestoreResponse(message: "initialized", success: false),
            stream: _checkOutBloc.transactionStream,
            builder: (BuildContext context,
                AsyncSnapshot<FirestoreResponse> transactionSnapshot) {
              final FirestoreResponse response = transactionSnapshot.data;
              print(response.message);
              return DoggoButton(
                enabled: formIsValid && response.message != "loading",
                text: "⚡️Claim Your DoggoBox Now⚡️",
                onPressed: () => _checkOutBloc.onDoggoBoxPurchased(
                    context, widget.email, _customer, _card, _address),
              );
            },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DoggoAppBar(
        preferredSize: Size.fromHeight(75.0),
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
              _buildApplePayButton(),
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
                  autofillHints: [AutofillHints.fullStreetAddress]),
              InfoTextField(
                label: "City",
                hintText: "San Francisco",
                onChanged: _onCityChanged,
                autofillHints: [AutofillHints.addressCity],
              ),
              _buildAddressTextFields(),
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
