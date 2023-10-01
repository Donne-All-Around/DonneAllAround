import 'package:flutter/material.dart';
import '../models/MemberDto.dart'; // MemberDto 클래스를 가져옵니다.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class UserProvider extends ChangeNotifier {
  MemberDto? _user; // 사용자 데이터를 저장

  MemberDto? get user => _user;
  final String baseUrl = "https://j9a705.p.ssafy.io";

  // 백엔드에서 사용자가 존재하는지 확인하는 함수
  Future<bool> checkUserExists(String phoneNumber) async {
    final url = "$baseUrl/api/member/check/tel?tel=$phoneNumber";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userExists = responseData['exists'];
        return userExists;
      } else {
        throw Exception('Failed to check user existence');
      }
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  // 백엔드에 새 사용자를 등록하는 함수
  Future<void> registerUser({
    required String phoneNumber,
    required String nickname,
    String? profileImg,
  }) async {
    final url = "$baseUrl/api/member/join";


    final Map<String, dynamic> userData = {
      "tel": phoneNumber,
      "nickname": nickname,
      "profileImg": profileImg ?? 'assets/image/wagon_don.png',
      // 나머지 필드는 null 값으로 전달합니다.
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(userData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newUser = MemberDto.fromJson(responseData);
        _user = newUser;
        notifyListeners();
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  Future<bool> checkNicknameExists(String nickname) async {
    final url = "$baseUrl/api/member/check/nickname?nickname=$nickname";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final nicknameExists = responseData['exists'];
        return nicknameExists;
      } else {
        throw Exception('Failed to check nickname existence');
      }
    } catch (e) {
      print('Error checking nickname existence: $e');
      return false;
    }
  }

  Future<String?> uploadImage(String imagePath) async {
    final dio = Dio();
    final apiUrl = "https://example.com/upload/image";

    try {
      // FormData를 사용하여 이미지 파일의 경로를 요청에 추가
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imagePath,
          filename: "image.jpg",
        ),
      });

      // 이미지 업로드를 위한 POST 요청 보내기
      final response = await dio.post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        final imageUrl = response.data['imageUrl']; // 서버에서 반환된 이미지 URL
        return imageUrl;
      } else {
        // 업로드 실패 시, null 반환
        return null;
      }
    } catch (e) {
      // 오류 발생 시, null 반환
      print('Error uploading image: $e');
      return null;
    }
  }

}
