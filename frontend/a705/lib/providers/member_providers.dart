import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/MemberDto.dart'; // MemberDto 클래스를 가져옵니다.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
      "profileImg": profileImg ?? 'assets/images/wagon_don.png',
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

  Future<String?> uploadImage(File imageFile) async {
    try {
      final String fileExtension = imageFile.path.split('.').last; // 파일 확장자 추출
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${Uuid().v1()}.$fileExtension'); // 이미지 파일명을 고유하게 생성

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      final imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<String?> getJwtTokenFromFirebaseToken(String firebaseToken, String uid, String tel) async {
    final url = "$baseUrl/api/member/verifyFirebaseToken";

    // Prepare the request body with the firebaseToken, uid, and tel
    final requestBody = {
      'firebaseToken': firebaseToken,
      'uid': uid,
      'tel': tel,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final jwtToken = responseData['jwtToken'];
        return jwtToken;
      } else {
        throw Exception('Firebase 토큰으로부터 JWT 토큰을 가져오지 못했습니다');
      }
    } catch (e) {
      print('Firebase 토큰으로부터 JWT 토큰을 가져오는 중 오류 발생: $e');
      return null;
    }
  }
  //
  // Future<SignInResponse?> getSignInResponseFromFirebaseToken(String firebaseToken, String uid, String tel) async {
  //   final url = "$baseUrl/api/member/verifyFirebaseToken";
  //
  //   // Prepare the request body with the firebaseToken, uid, and tel
  //   final requestBody = {
  //     'firebaseToken': firebaseToken,
  //     'uid': uid,
  //     'tel': tel,
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(requestBody),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       final isMember = responseData['isMember'];
  //
  //       if (isMember) {
  //         final signInResponseData = responseData['signInResponse'];
  //         final signInResponse = SignInResponse(
  //           id: signInResponseData['id'],
  //           tel: signInResponseData['tel'],
  //           token: signInResponseData['token'],
  //         );
  //         return signInResponse;
  //       } else {
  //         // 새로운 회원인 경우
  //         return null;
  //       }
  //     } else {
  //       throw Exception('Firebase 토큰으로부터 응답을 가져오지 못했습니다. 상태 코드: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Firebase 토큰으로부터 응답을 가져오는 중 오류 발생: $e');
  //     return null;
  //   }
  // }

}
