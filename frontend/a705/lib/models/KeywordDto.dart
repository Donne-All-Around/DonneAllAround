class KeywordDto {
  final int id;
  final int memberId;
  final String countryCode;
  final String preferredTradeCountry;
  final String preferredTradeCity;
  final String preferredTradeDistrict;
  final String preferredTradeTown;

  KeywordDto({
    required this.id,
    required this.memberId,
    required this.countryCode,
    required this.preferredTradeCountry,
    required this.preferredTradeCity,
    required this.preferredTradeDistrict,
    required this.preferredTradeTown,
  });

  factory KeywordDto.fromJson(Map<String, dynamic> json) {
    return KeywordDto(
      id: json['id'],
      memberId: json['memberId'],
      countryCode: json['countryCode'],
      preferredTradeCountry: json['preferredTradeCountry'],
      preferredTradeCity: json['preferredTradeCity'],
      preferredTradeDistrict: json['preferredTradeDistrict'],
      preferredTradeTown: json['preferredTradeTown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'countryCode': countryCode,
      'preferredTradeCountry': preferredTradeCountry,
      'preferredTradeCity': preferredTradeCity,
      'preferredTradeDistrict': preferredTradeDistrict,
      'preferredTradeTown': preferredTradeTown,
    };
  }
}
