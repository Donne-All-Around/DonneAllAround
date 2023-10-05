class LoginResponse {
  final bool firebaseAuthStatus;
  final bool member;
  final ResponseData signInResponse;

  LoginResponse({
    required this.firebaseAuthStatus,
    required this.member,
    required this.signInResponse,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      firebaseAuthStatus: json['firebaseAuthStatus'],
      member: json['member'],
      signInResponse: ResponseData.fromJson(json['signInResponse']),
    );
  }
}

class ResponseData {
  final int id;
  final String nickname;
  final String tel;
  final TokenData token;

  ResponseData({
    required this.id,
    required this.nickname,
    required this.tel,
    required this.token,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json['id'],
      nickname: json['nickname'],
      tel: json['tel'],
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