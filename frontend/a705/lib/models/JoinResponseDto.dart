class ApiResponse {
  final String status;
  final String message;
  final UserData data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final int id;
  final String tel;
  final TokenData token;
  final String nickname;

  UserData({
    required this.id,
    required this.tel,
    required this.token,
    required this.nickname,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      tel: json['tel'],
      nickname : json['nickname'],
      token: TokenData.fromJson(json['token']),
    );
  }
}

class TokenData {
  final String grantType;
  final String accessToken;
  final String refreshToken;

  TokenData({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      grantType: json['grantType'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}