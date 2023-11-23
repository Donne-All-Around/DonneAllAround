import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/JoinDto.dart';
import '../models/LoginDto.dart';
import '../models/MemberDto.dart'; // MemberDto 클래스를 가져옵니다.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage.dart';

class UserProvider extends ChangeNotifier {
  MemberDto? _user; // 사용자 데이터를 저장

  MemberDto? get user => _user;

  String? baseUrl = dotenv.env['BASE_URL'];

  // 백엔드에서 사용자가 존재하는지 확인하는 함수 (전화 번호 체크 - 사실상 필요 없긴함)
  Future<bool> checkUserExists(String phoneNumber) async {
    final url = "$baseUrl/member/check/tel?tel=$phoneNumber";

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
      Uri.parse('$baseUrl/member/join'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(signUpDto.toJson()),
    );

    if (response.statusCode == 200) {
      // final responseBody = jsonDecode(response.body); 한글 깨져서
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('회원가입 후 백엔드에서 받는 응답확인: $responseBody');
      return responseBody;
      // id/ tel / token 나누거나 사용하는 곳에서 나눠도 됨.
    } else {
      // 서버로부터 오류 응답을 처리하는 코드
      throw Exception('Failed to sign up');
    }
  }


// 닉네임 체크 
  Future<String> checkNickname(String nickname) async {
    final url = "$baseUrl/member/check/nickname";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nickname': nickname,
        }),
      );
      print('응답: $response');
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


  // // 이미지 firebasestore 에 업로드 및 url 변환
  // Future<String?> uploadImage(File imageFile) async {
  //   try {
  //     final String fileExtension = imageFile.path.split('.').last; // 파일 확장자 추출
  //     final Reference storageReference = FirebaseStorage.instance
  //         .ref()
  //         .child('profile_images/${Uuid().v1()}.$fileExtension'); // 이미지 파일명을 고유하게 생성
  //
  //     final UploadTask uploadTask = storageReference.putFile(imageFile);
  //     await uploadTask.whenComplete(() => null);
  //
  //     final imageUrl = await storageReference.getDownloadURL();
  //     return imageUrl;
  //   } catch (e) {
  //     print('Error uploading image to Firebase Storage: $e');
  //     return null;
  //   }
  // }



  Future<String?> getJwtTokenFromFirebaseToken(String firebaseToken, String uid,
      String tel) async {
    final url = "$baseUrl/member/sign-in";

    // Prepare the request body with the firebaseToken, uid, and tel
    final requestBody = {
      "idToken": firebaseToken,
      "uid": uid,
      "tel": tel,
    };
    // print('보내는 파베토큰 : ${requestBody['idToken']}');
    // print('보내는 uid : ${requestBody['uid']}');
    // print('보내는 tel : ${requestBody['tel']}');
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

        // 파이어베이스 토큰 인증 성공
        if (responseData['firebaseAuthStatus'] == true) {

          final signInResponseJson = responseData['signInResponse'];

          if (signInResponseJson != null) {
            final signInResponse = LoginResponse.fromJson(signInResponseJson);
            int id = signInResponse.signInResponse.id;
            String tel = signInResponse.signInResponse.tel;
            String accessToken = signInResponse.signInResponse.token.accessToken;
            String refreshToken = signInResponse.signInResponse.token.refreshToken;
            String nickname = signInResponse.signInResponse.nickname;

            // print('너의 member id : $id');
            // print('너의 전번 : $tel');
            // print('너의 accessToken 토큰 값: $accessToken');
            // print('너의 refreshToken 토큰 값: $refreshToken');
            // print('너의 닉네임 : $nickname');

            // 스토리지에 저장.
            await saveUserInfo(id, tel, nickname, accessToken, refreshToken);

            return 'SUCCESS';
          } else {
            print("기존 멤버가 아니라서 회원가입페이지로 갈거야!");
            // 스타트펭지 또는 예외 처리 추가
            return null; // 예외 처리에 따라 반환값을 수정
          }
        }
      }
    } catch (e) {
      print('백엔드서버에서 토큰 가져오는 중 오류 발생: $e');
      // 스타트페이지
    }
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


