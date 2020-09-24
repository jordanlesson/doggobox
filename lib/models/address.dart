import 'package:doggobox/index.dart';

class Address {
  String line1;
  String city;
  String country;
  String line2;
  String postalCode;
  String state;

  // CHECKS IF STREET ADDRESS IS VALID (2 CHARACTERS)
  bool isLine1Valid() {
    if (line1 == null) {
      return false;
    }
    return line1.length >= 2;
  }

  // CHECKS IF CITY IS VALID (2 CHARACTERS)
  bool isCityValid() {
    if (city == null) {
      return false;
    }
    return city.length >= 2;
  }

  // CHECKS IF ZIP CODE IS VALID (2 CHARACTERS)
  bool isPostalCodeValid() {
    if (postalCode == null) {
      return false;
    }
    return Validators.isNumeric(postalCode) && postalCode.length == 5;
  }

  // CHECKS IF STATE IS VALID (2 CHARACTERS)
  bool isStateValid() {
    if (state == null) {
      return false;
    }
    return state.length >= 2;
  }

  bool isAddressInfoValid() {
    return this.isLine1Valid() &&
        this.isCityValid() &&
        this.isPostalCodeValid() &&
        this.isStateValid();
  }
}
