// 은행 api
class ExchangeRateResponse {
  bool success;
  String terms;
  String privacy;
  int timestamp;
  String source;
  ExchangeRates quotes;

  ExchangeRateResponse({
    required this.success,
    required this.terms,
    required this.privacy,
    required this.timestamp,
    required this.source,
    required this.quotes,
  });

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(
      success: json['success'],
      terms: json['terms'],
      privacy: json['privacy'],
      timestamp: json['timestamp'],
      source: json['source'],
      quotes: ExchangeRates.fromJson(json['quotes']),
    );
  }
}

class ExchangeRates {
  double usdKrw;
  double usdJpy;
  double usdAud;
  double usdCad;
  double usdCny;
  double usdCzk;
  double usdEur;
  double usdGbp;
  double usdHkd;
  double usdNzd;
  double usdPhp;
  double usdRub;
  double usdSgd;
  double usdTwd;
  double usdVnd;


  ExchangeRates({
    required this.usdKrw,
    required this.usdJpy,
    required this.usdAud,
    required this.usdCad,
    required this.usdCny,
    required this.usdCzk,
    required this.usdEur,
    required this.usdGbp,
    required this.usdHkd,
    required this.usdNzd,
    required this.usdPhp,
    required this.usdRub,
    required this.usdSgd,
    required this.usdTwd,
    required this.usdVnd,
  });

  factory ExchangeRates.fromJson(Map<String, dynamic> json) {
    return ExchangeRates(
      usdKrw: json['USDKRW'],
      usdJpy: json['USDJPY'],
    );
  }
}