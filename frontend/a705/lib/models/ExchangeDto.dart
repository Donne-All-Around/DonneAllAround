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
      usdKrw: json['USDKRW'].toDouble(),
      usdJpy: json['USDJPY'].toDouble(),
      usdCny: json['USDCNY'].toDouble(),
      usdEur: json['USDEUR'].toDouble(),
      usdGbp: json['USDGBP'].toDouble(),
      usdAud: json['USDAUD'].toDouble(),
      usdCad: json['USDCAD'].toDouble(),
      usdHkd: json['USDHKD'].toDouble(),
      usdPhp: json['USDPHP'].toDouble(),
      usdVnd: json['USDVND'].toDouble(),
      usdTwd: json['USDTWD'].toDouble(),
      usdSgd: json['USDSGD'].toDouble(),
      usdCzk: json['USDCZK'].toDouble(),
      usdNzd: json['USDNZD'].toDouble(),
      usdRub: json['USDRUB'].toDouble(),

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