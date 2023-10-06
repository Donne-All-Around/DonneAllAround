class ExchangeRateData {
  final bool success;
  final String terms;
  final String privacy;
  final bool historical;
  final String date;
  final int timestamp;
  final String source;
  final Map<String, double> quotes;

  ExchangeRateData({
    required this.success,
    required this.terms,
    required this.privacy,
    required this.historical,
    required this.date,
    required this.timestamp,
    required this.source,
    required this.quotes,
  });

  factory ExchangeRateData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> quotesMap = json['quotes'];

    return ExchangeRateData(
      success: json['success'],
      terms: json['terms'],
      privacy: json['privacy'],
      historical: json['historical'],
      date: json['date'],
      timestamp: json['timestamp'],
      source: json['source'],
      quotes: Map<String, double>.from(quotesMap),
    );
  }
}
