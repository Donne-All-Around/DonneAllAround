class TradeDto {
  final int id;
  final int sellerId;
  final String title;
  final String description;
  final String thumbnailImageUrl;
  final String status;
  final String countryCode;
  final int foreignCurrencyAmount;
  final int koreanWonAmount;
  final double koreanWonPerForeignCurrency;
  final double latitude;
  final double longitude;
  final String preferredTradeCountry;
  final String preferredTradeCity;
  final String preferredTradeDistrict;
  final String preferredTradeTown;
  final List<dynamic> imageUrlList;
  late int tradeLikeCount;
  final String sellerNickname;
  final String sellerImgUrl;
  final int sellerRating;
  late bool isLike;
  final String createTime;

  TradeDto({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.thumbnailImageUrl,
    required this.status,
    required this.countryCode,
    required this.foreignCurrencyAmount,
    required this.koreanWonAmount,
    required this.koreanWonPerForeignCurrency,
    required this.latitude,
    required this.longitude,
    required this.preferredTradeCountry,
    required this.preferredTradeCity,
    required this.preferredTradeDistrict,
    required this.preferredTradeTown,
    required this.imageUrlList,
    required this.tradeLikeCount,
    required this.sellerNickname,
    required this.sellerImgUrl,
    required this.sellerRating,
    required this.isLike,
    required this.createTime,
  });

  factory TradeDto.fromJson(Map<String, dynamic> json) {
    return TradeDto(
      id: json['id'],
      sellerId: json['sellerId'] ?? 1,
      title: json['title'].toString(),
      description: json['description'].toString() ?? "hello",
      thumbnailImageUrl: json['thumbnailImageUrl'].toString() ?? "4444.png",
      status: json['status'].toString(),
      countryCode: json['countryCode'].toString(),
      foreignCurrencyAmount: json['foreignCurrencyAmount'],
      koreanWonAmount: json['koreanWonAmount'],
      koreanWonPerForeignCurrency: json['koreanWonPerForeignCurrency'],
      latitude: json['latitude'] ?? 37,
      longitude: json['longitude'] ?? 127,
      preferredTradeCountry: json['preferredTradeCountry'].toString(),
      preferredTradeCity: json['preferredTradeCity'].toString(),
      preferredTradeDistrict: json['preferredTradeDistrict'].toString(),
      preferredTradeTown: json['preferredTradeTown'].toString(),
      imageUrlList: json['imageUrlList'] ?? [],
      tradeLikeCount: json['tradeLikeCount'] ?? 0,
      sellerNickname: json['sellerNickname'].toString() ?? "옹골찬",
      sellerImgUrl: json['sellerImgUrl'].toString() ?? "4444.png",
      sellerRating: json['sellerRating'] ?? 1,
      isLike: json['isLike'] ?? false,
      createTime: json['createTime'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'thumbnailImageUrl': thumbnailImageUrl,
      'status': status,
      'countryCode': countryCode,
      'foreignCurrencyAmount': foreignCurrencyAmount,
      'koreanWonAmount': koreanWonAmount,
      'koreanWonPerForeignCurrency': koreanWonPerForeignCurrency,
      'latitude': latitude,
      'locationLongitude': longitude,
      'preferredTradeCountry': preferredTradeCountry,
      'preferredTradeCity': preferredTradeCity,
      'preferredTradeDistrict': preferredTradeDistrict,
      'preferredTradeTown': preferredTradeTown,
      'imageUrlList': imageUrlList,
      'tradeLikeCount': tradeLikeCount,
      'sellerNickname': sellerNickname,
      'sellerImgUrl': sellerImgUrl,
      'sellerRating': sellerRating,
      'isLike': isLike,
      'createTime': createTime,
    };
  }
}
