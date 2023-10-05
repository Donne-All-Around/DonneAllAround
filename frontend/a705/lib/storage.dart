import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

const storage = FlutterSecureStorage();

Future<void> saveUserInfo(int id, String tel, String token) async {
  await storage.write(key: 'userId', value: id.toString());
  await storage.write(key: 'userTel', value: tel);
  await storage.write(key: 'jwtToken', value: token);

  final jwtToken = await storage.read(key: 'jwtToken');
  print(await storage.read(key: 'jwtToken'));
  print('스토리지 저장 확인: $jwtToken');
  if (jwtToken != null) {
    final tokenData = jsonDecode(jwtToken);

    // "accessToken"과 "refreshToken" 추출
    final accessToken = tokenData['accessToken'];
    final refreshToken = tokenData['refreshToken'];
    print('스토리지 accessToken파싱된 것 : $accessToken');
    print('스토리지 refreshToken파싱된 것 : $refreshToken');
    // 각각의 값을 저장
    await storage.write(key: 'jwtAccessToken', value: accessToken);
    await storage.write(key: 'jwtRefreshToken', value: refreshToken);
  }
}

Future<int> getUserId() async {
  String? id = await storage.read(key: 'userId');
  return int.parse(id!);
}

Future<String?> getUserTel() async {
  return await storage.read(key: 'userTel');
}

Future<String?> getJwtToken() async {
  return await storage.read(key: 'jwtToken');
}

Future<String?> getJwtAccessToken() async {
  return await storage.read(key: 'jwtAccessToken');
}

Future<String?> getJwtRefreshToken() async {
  return await storage.read(key: 'jwtRefreshToken');
}


const baseUrl = 'https://j9a705.p.ssafy.io'; // 기본 URL을 사용자의 백엔드 URL로 대체

Future<String?> refreshTokenAndRetrieveAccessToken(String refreshToken) async {
  try {
    final url = '$baseUrl/api/member/reissue';

    // 리프레시 토큰을 요청 바디에 담아서 POST 요청을 보냅니다.
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newAccessToken = responseData['data']['accessToken'];

      // 갱신된 어세스 토큰을 스토리지에 저장합니다.
      await storage.write(key: 'jwtAccessToken', value: newAccessToken);

      print('AccessToken 이 갱신되었습니다: $newAccessToken');
      return newAccessToken;
    } else {
      print('AccessToken 갱신 실패 정보 삭제 및 로그인 이동');
      // 스토리지 삭제 및 파이어베이스 uid (사용자) 삭제 그리고 로그아웃 토스트 보여주고 페이지 이동.
      logoutAndNavigateToLogin();
    }
  } catch (e) {
    print('리프레시 토큰 갱신 중 오류 발생: $e');
    return null;
  }
}


// 토스트 메시지
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black45,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

// 유저 정보(스토리지 저장된 값 & 파베 정보) 삭제 후 로그인 페이지 이동
void logoutAndNavigateToLogin() async {
  final user = FirebaseAuth.instance.currentUser;

  // 스토리지 저장값 삭제
  await  storage.deleteAll();

  // 사용자 삭제
  if (user != null) {
    await user.delete();
  }

  // 토스트 메시지 표시
  showToast('토큰 갱신 실패로 로그아웃 됩니다');

  // 로그인 페이지로 이동
  navigatorKey.currentState?.pushNamed('/login');

}
