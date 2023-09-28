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
  double usdCny;
  double usdEur;
  double usdGbp;
  double usdAud;
  double usdCad;
  double usdHkd;
  double usdPhp;
  double usdVnd;
  double usdTwd;
  double usdSgd;
  double usdCzk;
  double usdNzd;
  double usdRub;


  ExchangeRates({
    required this.usdKrw,
    required this.usdJpy,
    required this.usdCny,
    required this.usdEur,
    required this.usdGbp,
    required this.usdAud,
    required this.usdCad,
    required this.usdHkd,
    required this.usdPhp,
    required this.usdVnd,
    required this.usdTwd,
    required this.usdSgd,
    required this.usdCzk,
    required this.usdNzd,
    required this.usdRub,

  });

  factory ExchangeRates.fromJson(Map<String, dynamic> json) {
    return ExchangeRates(
      usdKrw: json['USDKRW'],
      usdJpy: json['USDJPY'],
      usdCny: json['USDCNY'],
      usdEur: json['USDEUR'],
      usdGbp: json['USDGBP'],
      usdAud: json['USDAUD'],
      usdCad: json['USDCAD'],
      usdHkd: json['USDHKD'],
      usdPhp: json['USDPHP'],
      usdVnd: json['USDVND'],
      usdTwd: json['USDTWD'],
      usdSgd: json['USDSGD'],
      usdCzk: json['USDCZK'],
      usdNzd: json['USDNZD'],
      usdRub: json['USDRUB'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'USDKRW' : usdKrw,
      'USDJPY' : usdJpy,
      'USDCNY' : usdCny,
      'USDEUR' : usdEur,
      'USDGBP' : usdGbp,
      'USDAUD' : usdAud,
      'USDCAD' : usdCad,
      'USDHKD' : usdHkd,
      'USDPHP' : usdPhp,
      'USDVND' : usdVnd,
      'USDTWD' : usdTwd,
      'USDSGD' : usdSgd,
      'USDCZK' : usdCzk,
      'USDNZD' : usdNzd,
      'USDRUB' : usdRub,


    };
  }

}