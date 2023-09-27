class Trade {
  final BigInt id;
  final BigInt sellerId;
  final String thumbnailImage;
  final String title;
  final String countryCode;
  final int foreignCurrencyAmount;
  final int koreanWonAmount;
  final String status;
  final String type;
  final BigInt buyerId;
  final String directTradeTime;
  final String directTradeLocationDetail;
  final String sellerAccountBankCode;
  final String sellerAccountNumber;
  final String deliveryRecipientName;
  final String deliveryRecipientTel;
  final String deliveryAddressZipCode;
  final String deliveryAddress;
  final String deliveryAddressDetail;
  final String trackingNumber;
  final String createTime;

  Trade(
    this.id,
    this.sellerId,
    this.thumbnailImage,
    this.title,
    this.countryCode,
    this.foreignCurrencyAmount,
    this.koreanWonAmount,
    this.status,
    this.type,
    this.buyerId,
    this.directTradeTime,
    this.directTradeLocationDetail,
    this.sellerAccountBankCode,
    this.sellerAccountNumber,
    this.deliveryRecipientName,
    this.deliveryRecipientTel,
    this.deliveryAddressZipCode,
    this.deliveryAddress,
    this.deliveryAddressDetail,
    this.trackingNumber,
    this.createTime,
  );

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      BigInt.from(json['id']),

      BigInt.from(json['sellerId']),

      json['thumbnailImage'].toString(),
      json['title'].toString(),
      json['countryCode'].toString(),
      json['foreignCurrencyAmount'],
      json['koreanWonAmount'],
      json['status'].toString(),
      json['type'].toString(),
      BigInt.from(json['buyerId'] ?? 0),

      json['directTradeTime'].toString(),
      json['directTradeLocationDetail'].toString(),
      json['sellerAccountBankCode'].toString(),
      json['sellerAccountNumber'].toString(),
      json['deliveryRecipientName'].toString(),
      json['deliveryRecipientTel'].toString(),
      json['deliveryAddressZipCode'].toString(),
      json['deliveryAddress'].toString(),
      json['deliveryAddressDetail'].toString(),
      json['trackingNumber'].toString(),
      json['createTime'].toString(),
    );
  }
}
