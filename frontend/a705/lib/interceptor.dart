import 'dart:async';
import 'package:a705/storage.dart';
import 'package:http/http.dart' as http;

class TokenInterceptor extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 스토리지에서 어세스 토큰을 가져옵니다.
    final String? accessToken = await getJwtAccessToken();

    // 요청 헤더에 어세스 토큰을 추가합니다.
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await _client.send(request);

    // 403 에러가 발생하면 리프레시 토큰을 사용하여 어세스 토큰을 갱신합니다.
    if (response.statusCode == 403) {
      final String? refreshToken = await getJwtRefreshToken();

      if (refreshToken != null) {
        final newAccessToken = await refreshTokenAndRetrieveAccessToken(refreshToken);

        if (newAccessToken != null) {
          // 이전 요청을 다시 보냅니다.
          request.headers['Authorization'] = 'Bearer $newAccessToken';
          return _client.send(request);
        }
      }
    }

    return response;
  }
}