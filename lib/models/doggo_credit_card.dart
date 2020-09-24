import 'package:doggobox/index.dart';

class DoggoCreditCard {
  String cardNumber;
  String cvcCode;
  String expDate;

  DoggoCreditCard({
    this.cardNumber,
    this.cvcCode,
    this.expDate,
  });

  // CHECKS IF CREDIT CARD NUMBER IS VALID (16 DIGITS)
  bool isCardNumberValid(String number) {
    if (number == null) {
      return false;
    }
    Map<String, dynamic> cardData =
        CreditCardValidator.getCard(number.replaceAll(" ", ""));

    bool isCardNumberValid = cardData[CreditCardValidator.isValidCard];
    final bool isValid = Validators.isNumeric(number.replaceAll(" ", "")) &&
        number.replaceAll(" ", "").length == 16 &&
        isCardNumberValid;

    return isValid;
  }

  // CHECKS IF CREDIT CARD CVC CODE IS VALID (3 DIGITS)
  bool isCVCValid(String cvc) {
    if (cvc == null) {
      return false;
    }
    final bool isValid = Validators.isNumeric(cvc) && cvc.length == 3;

    return isValid;
  }

  // CHECKS IF CREDIT CARD EXPIRATION DATE CODE IS VALID (MONTH AND YEAR SHOULD BE 2 DIGITS)
  bool isExpDateValid(int expMonth, int expYear) {
    if (expMonth == null || expYear == null) {
      return false;
    }
    DateTime currentDate = DateTime.now();
    if ((expYear == currentDate.year && expMonth < currentDate.month) ||
        (expYear < currentDate.year)) {
      return false;
    }

    return true;
  }

  // FUNCTION THAT CHECKS WHETHER CREDIT CARD IS VALID
  bool checkCreditCardInfo(CreditCard card) {
    return isCardNumberValid(card.number) &&
        isCVCValid(card.cvc) &&
        isExpDateValid(card.expMonth, card.expYear);
  }
}
