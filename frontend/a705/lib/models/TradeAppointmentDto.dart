class TradeAppointmentDto {
  final int id;
  final int sellerId;
  final String thumbnailImage;
  final String title;
  final String countryCode;
  final int foreignCurrencyAmount;
  final int koreanWonAmount;
  final String status;
  final String type;
  final int? buyerId;
  final String? directTradeTime;
  final String? directTradeLocationDetail;
  final String? sellerAccountBankCode;
  final String? sellerAccountNumber;
  final String? deliveryRecipientName;
  final String? deliveryRecipientTel;
  final String? deliveryAddressZipCode;
  final String? deliveryAddress;
  final String? deliveryAddressDetail;
  final String? trackingNumber;
  final String? createTime;

  TradeAppointmentDto({
    required this.id,
    required this.sellerId,
    required this.thumbnailImage,
    required this.title,
    required this.countryCode,
    required this.foreignCurrencyAmount,
    required this.koreanWonAmount,
    required this.status,
    required this.type,
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
  });

  factory TradeAppointmentDto.fromJson(Map<String, dynamic> json) {
    return TradeAppointmentDto(
      id: json['id'],
      sellerId: json['sellerId'],
      thumbnailImage: json['thumbnailImage'],
      title: json['title'],
      countryCode: json['countryCode'],
      foreignCurrencyAmount: json['foreignCurrencyAmount'],
      koreanWonAmount: json['koreanWonAmount'],
      status: json['status'],
      type: json['type'],
      buyerId: json['buyerId'],
      directTradeTime: json['directTradeTime'],
      directTradeLocationDetail: json['directTradeLocationDetail'],
      sellerAccountBankCode: json['sellerAccountBankCode'],
      sellerAccountNumber: json['sellerAccountNumber'],
      deliveryRecipientName: json['deliveryRecipientName'],
      deliveryRecipientTel: json['deliveryRecipientTel'],
      deliveryAddressZipCode: json['deliveryAddressZipCode'],
      deliveryAddress: json['deliveryAddress'],
      deliveryAddressDetail: json['deliveryAddressDetail'],
      trackingNumber: json['trackingNumber'],
      createTime: json['createTime'],
    );
  }
}
