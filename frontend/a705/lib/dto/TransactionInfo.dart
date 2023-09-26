class TransactionInfo {
  final BigInt id;
  final BigInt sellerId;
  final String thumbnailImage;
  final String title;
  final String countryCode;
  final BigInt foreignCurrencyAmount;
  final BigInt koreanWonAmount;
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

  TransactionInfo(
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

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return TransactionInfo(
      BigInt.parse(json['id'].toString()),
      BigInt.parse(json['sellerId'].toString()),
      json['thumbnailImage'] as String,
      json['title'] as String,
      json['countryCode'] as String,
      BigInt.parse(json['foreignCurrencyAmount'].toString()),
      BigInt.parse(json['koreanWonAmount'].toString()),
      json['status'] as String,
      json['type'] as String,
      BigInt.parse(json['buyerId'].toString()),
      json['directTradeTime'] as String,
      json['directTradeLocationDetail'] as String,
      json['sellerAccountBankCode'] as String,
      json['sellerAccountNumber'] as String,
      json['deliveryRecipientName'] as String,
      json['deliveryRecipientTel'] as String,
      json['deliveryAddressZipCode'] as String,
      json['deliveryAddress'] as String,
      json['deliveryAddressDetail'] as String,
      json['trackingNumber'] as String,
      json['createTime'] as String,
    );
  }
}
