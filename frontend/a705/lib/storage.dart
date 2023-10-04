import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveUserInfo(String id, String tel, String token) async {
  await storage.write(key: 'userId', value: id);
  await storage.write(key: 'userTel', value: tel);
  await storage.write(key: 'jwtToken', value: token);
}

Future<String?> getUserId() async {
  return await storage.read(key: 'userId');
}

Future<String?> getUserTel() async {
  return await storage.read(key: 'userTel');
}

Future<String?> getJwtToken() async {
  return await storage.read(key: 'jwtToken');
}

// 자동 갱신 주기 (예: 30분마다)
const autoRefreshInterval = Duration(minutes: 30);

void startTokenAutoRefresh() {
  Timer.periodic(autoRefreshInterval, (timer) async {
    final currentToken = await getJwtToken();
    if (currentToken != null) {
      DateTime currentTime;
      final expirationTime =  currentTime = DateTime.now();

      // 토큰이 만료되기 전에 갱신
      if (expirationTime != null && expirationTime.isBefore(currentTime.add(autoRefreshInterval))) {
        final newToken = await refreshToken(); // 새 토큰 얻기 (백엔드와의 통신 필요)
        if (newToken != null) {
          final id = await getUserId(); // 저장된 사용자 ID 가져오기
          final tel = await getUserTel(); // 저장된 사용자 전화번호 가져오기
          await saveUserInfo(id!, tel!, newToken); // 새 토큰 저장
        }
      }
    }
  });
}

Future<String?> refreshToken() async {
  // 백엔드와의 통신을 통해 새 토큰을 얻어옵니다.
  // 성공적으로 얻었다면 새 토큰을 반환하고, 실패하면 null을 반환합니다.
}
