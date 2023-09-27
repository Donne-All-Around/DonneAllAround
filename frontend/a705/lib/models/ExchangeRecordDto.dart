class ExchangeRecordDto {
  final int id;
  final int memberId;
  final String countryCode;
  final String bankCode;
  final String exchangeDate;
  final int koreanWonAmount;
  final int foreignCurrencyAmount;
  final int preferentialRate;
  final double tradingBaseRate;

  ExchangeRecordDto({
    required this.id,
    required this.memberId,
    required this.countryCode,
    required this.bankCode,
    required this.exchangeDate,
    required this.koreanWonAmount,
    required this.foreignCurrencyAmount,
    required this.preferentialRate,
    required this.tradingBaseRate
});

  factory ExchangeRecordDto.fromJson(Map<String, dynamic> json) {
    return ExchangeRecordDto(
        id: json['id'],
        memberId: json['memberId'],
        countryCode: json['countryCode'],
        bankCode: json['bankCode'],
        exchangeDate: json['exchangeDate'],
        koreanWonAmount: json['koreanWonAmount'],
        foreignCurrencyAmount: json['foreignCurrencyAmount'],
        preferentialRate: json['preferentialRate'],
        tradingBaseRate: json['tradingBaseRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'countryCode': countryCode,
      'bankCode': bankCode,
      'exchangeDate': exchangeDate,
      'koreanWonAmount': koreanWonAmount,
      'foreignCurrencyAmount': foreignCurrencyAmount,
      'preferentialRate': preferentialRate,
      'tradingBaseRate': tradingBaseRate,
    };
  }
}