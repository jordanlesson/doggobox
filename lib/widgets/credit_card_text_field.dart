import 'package:doggobox/index.dart';

class CreditCardTextField extends StatefulWidget {
  final void Function(CreditCard) onCreditCardChanged;

  CreditCardTextField({
    @required this.onCreditCardChanged,
    Key key,
  }) : super(key: key);

  @override
  _CreditCardTextFieldState createState() => _CreditCardTextFieldState();
}

class _CreditCardTextFieldState extends State<CreditCardTextField> {
  CreditCard _card;

  @override
  void initState() {
    super.initState();
    _card = CreditCard();
  }

  Widget _buildCardNumberTextField() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                autofillHints: [AutofillHints.creditCardNumber],
                onChanged: (String number) {
                  _card.number = number.replaceAll(" ", "");

                  widget.onCreditCardChanged(_card);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: "1234 1234 1234 1234",
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
                  MaskedTextInputFormatter(
                    mask: "xxxx xxxx xxxx xxxx",
                    separator: " ",
                  ),
                ],
              ),
            ),
            Container(
              height: 23.0,
              margin: EdgeInsets.only(right: 5.0),
              child: Image(
                image: AssetImage("assets/credit_cards_2x.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpirationDateTextField() {
    return Expanded(
      child: Container(
        child: TextField(
          onChanged: (String expDate) {
            if (expDate.length == 5) {
              _card.expMonth = int.parse(expDate.substring(0, 2));
              _card.expYear = 2000 + int.parse(expDate.substring(3, 5));

              widget.onCreditCardChanged(_card);
            }
          },
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              right: 20.0,
              left: 20.0,
            ),
            hintText: "MM/YY",
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
            MaskedTextInputFormatter(mask: "xx/xx", separator: "/"),
          ],
        ),
      ),
    );
  }

  Widget _buildCVCTextField() {
    return Expanded(
      child: Container(
        child: TextField(
          autofillHints: [AutofillHints.creditCardSecurityCode],
          onChanged: (String cvc) {
            _card.cvc = cvc;

            widget.onCreditCardChanged(_card);
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              right: 20.0,
              left: 20.0,
            ),
            hintText: "CVC",
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
            MaskedTextInputFormatter(mask: "xxx", separator: ""),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      //constraints: BoxConstraints(maxWidth: 350.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).accentColor.withOpacity(1.0),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          _buildCardNumberTextField(),
          // HORIZONTAL DIVIDER
          Container(
            height: 1.0,
            color: Colors.black.withOpacity(0.4),
          ),
          Expanded(
            child: Row(
              children: [
                _buildExpirationDateTextField(),
                // VERTICAL DIVIDER
                Container(
                  width: 1.0,
                  color: Colors.black.withOpacity(0.4),
                ),
                _buildCVCTextField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
