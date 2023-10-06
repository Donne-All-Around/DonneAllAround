import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeRateDto {
  double close;
  Timestamp date;

  ExchangeRateDto({
    required this.close,
    required this.date,
});



  factory ExchangeRateDto.fromJson(Map<String, dynamic> json) {
    return ExchangeRateDto(
      close: json["close"],
      date: json["date"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "close": close,
      "date": date,
    };
  }
}