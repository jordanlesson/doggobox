import 'package:doggobox/index.dart';

class Customer {
  Address address;
  String description;
  String email;
  Map<String, dynamic> metadata;
  String name;
  String paymentMethod;
  String phone;
  Map<String, dynamic> shipping;
  String customerId;

  Customer({
    this.address,
    this.description,
    this.email,
    this.metadata,
    this.name,
    this.paymentMethod,
    this.phone,
    this.shipping,
    this.customerId,
  });

  bool isNameValid() {
    return name != null && name.length >= 2;
  }
}

