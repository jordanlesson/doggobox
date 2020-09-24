class Price {
  String id;
  String currency;
  int unitAmount;
  String nickname;

  Price({
    this.id,
    this.currency,
    this.unitAmount,
    this.nickname,
  });

  factory Price.fromJson(Map<dynamic, dynamic> json) {
    return Price(
      id: json['id'],
      currency: json['currency'],
      unitAmount: json['unit_amount'],
      nickname: json['nickname'],
    );
  }
}

enum PaymentInterval {
  day,
  week,
  month,
  year,
}
