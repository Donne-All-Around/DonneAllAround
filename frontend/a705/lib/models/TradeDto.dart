class TradeDto {
  final int id;
  final int seller;
  final String title;
  final String description;
  final String thumbnailImageUrl;
  final String status;
  final String countryCode;
  final int foreignCurrencyAmount;
  final int koreanWonAmount;
  final double locationLatitude;
  final double locationLongitude;
  final String preferredTradeCountry;
  final String preferredTradeCity;
  final String preferredTradeDistrict;
  final String preferredTradeTown;
  final String type;
  final int isShow;
  final String directTradeTime;
  final String directTradeLocationDetail;
  final int buyer;
  final int isDeliveryReceived;

  TradeDto(
      {required this.id,
      required this.seller,
      required this.title,
      required this.description,
      required this.thumbnailImageUrl,
      required this.status,
      required this.countryCode,
      required this.foreignCurrencyAmount,
      required this.koreanWonAmount,
      required this.locationLatitude,
      required this.locationLongitude,
      required this.preferredTradeCountry,
      required this.preferredTradeCity,
      required this.preferredTradeDistrict,
      required this.preferredTradeTown,
      required this.type,
      required this.isShow,
      required this.directTradeTime,
      required this.directTradeLocationDetail,
      required this.buyer,
      required this.isDeliveryReceived});

  factory TradeDto.fromJson(Map<String, dynamic> json) {
    return TradeDto(
      id: json['id'],
      seller: json['seller'],
      title: json['title'],
      description: json['description'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      status: json['status'],
      countryCode: json['countryCode'],
      foreignCurrencyAmount: json['foreignCurrencyAmount'],
      koreanWonAmount: json['koreanWonAmount'],
      locationLatitude: json['locationLatitude'],
      locationLongitude: json['locationLongitude'],
      preferredTradeCountry: json['preferredTradeCountry'],
      preferredTradeCity: json['preferredTradeCity'],
      preferredTradeDistrict: json['preferredTradeDistrict'],
      preferredTradeTown: json['preferredTradeTown'],
      type: json['type'],
      isShow: json['isShow'],
      directTradeTime: json['directTradeTime'],
      directTradeLocationDetail: json['directTradeLocationDetail'],
      buyer: json['buyer'],
      isDeliveryReceived: json['isDeliveryReceived'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller': seller,
      'title': title,
      'description': description,
      'thumbnailImageUrl': thumbnailImageUrl,
      'status': status,
      'countryCode': countryCode,
      'foreignCurrencyAmount': foreignCurrencyAmount,
      'koreanWonAmount': koreanWonAmount,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'preferredTradeCountry': preferredTradeCountry,
      'preferredTradeCity': preferredTradeCity,
      'preferredTradeDistrict': preferredTradeDistrict,
      'preferredTradeTown': preferredTradeTown,
      'type': type,
      'isShow' :isShow,
      'directTradeTime': directTradeTime,
      'directTradeLocationDetail': directTradeLocationDetail,
      'buyer': buyer,
      'isDeliveryReceived': isDeliveryReceived,
    };
  }
}
