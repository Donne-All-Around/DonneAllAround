import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/JoinDto.dart';
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

  // 백엔드에서 사용자가 존재하는지 확인하는 함수 (전화 번호 체크 - 사실상 필요 없긴함)
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

  // 백엔드에 새 사용자를 등록하는 함수(회원가입)
  Future<Map<String, dynamic>?> signUp(SignUpDto signUpDto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/member/join'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(signUpDto.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      // 서버로부터 오류 응답을 처리하는 코드
      throw Exception('Failed to sign up');
    }
  }


// 닉네임 체크 
  Future<String> checkNickname(String nickname) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nickname': nickname,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String checkedNickname = data['data']['checkedNickname'];

        if (checkedNickname == 'SUCCESS') {
          // 중복되지 않음
          return 'SUCCESS';
        } else {
          // 중복됨
          return 'FAIL';
        }
      } else {
        // 서버에서 오류 응답
        return 'ERROR';
      }
    } catch (e) {
      // 네트워크 오류 등 예외 발생
      return 'ERROR';
    }
  }

  
  // 이미지 firebasestore 에 업로드 및 url 변환
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

  // 파베 토큰 주고 jwt 토큰 받아오기
  Future<Map<String, dynamic>?> getJwtTokenFromFirebaseToken(String firebaseToken, String uid, String tel) async {
    final url = "$baseUrl/api/member/sign-in";

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
        if (responseData['member'] == true) {
          final signInResponse = responseData['signInResponse'];
          if (signInResponse is Map<String, dynamic>) {
            final id = signInResponse['id'];
            final tel = signInResponse['tel'];
            final token = signInResponse['token'];
            print('$id');
            print('$tel');
            print('$token');
            return {
              'id': id,
              'tel': tel,
              'token': token,
            };
          }
        } else {
          print('뉴멤버환영');
          return null;
        }
      }
      throw Exception('Firebase 토큰으로부터 회원 정보를 가져오지 못했습니다');
    } catch (e) {
      print('Firebase 토큰으로부터 회원 정보를 가져오는 중 오류 발생: $e');
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
