import 'dart:async'; // 타이머
import 'package:a705/Login/join_page.dart';
import 'package:a705/Login/profilesetting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../home_page.dart';
import '../main_page.dart';
import '../providers/member_providers.dart';
import '../service/shared_pref.dart';
import '../storage.dart';

class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  @override
  State<PreLoginPage> createState() => _PreLoginPageState();

}

class _PreLoginPageState extends State<PreLoginPage> {

  TextEditingController phoneController = TextEditingController(); // 전화번호 입력값
  TextEditingController optCodeController = TextEditingController(); // 코드 입력값
  FirebaseAuth auth = FirebaseAuth.instance; // firebase 연동
  String verificationIDReceived = ""; // 인증 값
  bool otpCodeVisible = false; // 코드 보낸 거 확인 값
  int _remainingTime = 180; // 3분을 초 단위로 표현
  late Timer _timer;
  bool _isButtonEnabled = false; // 인증문자 받기 버튼 활성화 상태를 저장
  bool _isStartEnabled = false; // 시작하기 버튼 활성화 상태 저장 하는 변수
  UserProvider userProvider = UserProvider();

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel(); // 타이머 중지
          _isStartEnabled = false;
        }
      });
    });
  }

  String formatRemainingTime(int seconds) {  // 타이머 형식
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  bool isPhoneNumberValid(String phoneNumber) {
    // 전화번호의 길이가 11자리여야 유효.
    final numberValid = phoneNumber.length == 11;
    setState(() {
      _isButtonEnabled = numberValid;
    });
    return numberValid;
  }

  bool isOptCodeValid(String optCode) {
    // 코드의 길이가 6자리여야 유효.
    final optValid = optCode.length == 6;
    setState(() {
      _isStartEnabled = optValid;
    });
    return optValid;
  }

  @override
  void dispose(){ // 컨트롤러 객체가 제거 될 때 변수에 할당 된 메모리를 해제
    _timer.cancel(); // 페이지가 dispose될 때 타이머 종료
    phoneController.dispose();
    optCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            '휴대폰 번호로',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            '로그인 해주세요!',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration:  InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            // borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: '휴대폰 번호 ( - 없이 숫자만 입력)',
                          hintStyle: const TextStyle(fontSize: 14),
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            // textAlign: TextAlign.center,
                          ),
                          // contentPadding: EdgeInsets.all(20.0),
                        ),
                        onChanged: (text){
                          setState(() {
                            _isButtonEnabled = true;
                          });
                        },
                      ),
                      const SizedBox(height: 10,),
                      OutlinedButton(onPressed: (){
                        if (isPhoneNumberValid(phoneController.text)) {
                          verifyNumber();
                        } else {}
                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:_isButtonEnabled ? Colors.white : Colors.grey[300],
                            elevation: 0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 60,
                            width: double.infinity,
                            child: Text(otpCodeVisible == true ? "인증문자 재발송" : "인증문자 받기",
                            style:  TextStyle(color:  _isButtonEnabled ? Colors.black : Colors.grey, fontSize: 25,fontWeight: FontWeight.bold,),
                            textAlign: TextAlign.center,),
                          ),),
                      const SizedBox(height: 20,),
                      Visibility(
                        visible: otpCodeVisible,
                        child: TextField(
                          autofocus:otpCodeVisible,
                          controller: optCodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              // borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: '인증번호 6자리 입력',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixText: formatRemainingTime(_remainingTime),
                            suffixStyle: const TextStyle(color: Colors.red),
                            labelStyle: const TextStyle(
                              fontSize: 20,
                              // textAlign: TextAlign.center,
                            ),
                            // contentPadding: EdgeInsets.all(20.0),
                          ),
                          onChanged: (text){
                            setState(() {
                              _isStartEnabled = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Visibility(
                        visible: otpCodeVisible,
                        child: ElevatedButton(onPressed: (){
                          if (isOptCodeValid(optCodeController.text)) {
                            verifyCode();
                          } else {}
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isStartEnabled ?  const Color(0xFFFFD954) : Colors.grey[300],
                              elevation: 0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 60,
                              width: double.infinity,
                              child: const Text("시작하기",
                                style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold,),
                                textAlign: TextAlign.center,),
                            ),),
                      ),
                    ],
                  )
              ),

            ),

          ),

        )
    );
  }

  // 전화번호 입력 후 firebase로 코드 보내는 기능
  void verifyNumber(){
    String totalPhoneNumber = "+82${phoneController.text.substring(1)}";
    auth.verifyPhoneNumber(
        phoneNumber: totalPhoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async{
      await auth.signInWithCredential(credential).then((value){
        print('로그인 성공');
      });
    },verificationFailed: (FirebaseAuthException exception){
      print(exception.message);
    },
      codeSent: (String verificationID, int? resendToken){
          verificationIDReceived = verificationID;
          otpCodeVisible = true;
          _remainingTime = 180;
          startTimer();
          setState(() {
            
          });
      },
      codeAutoRetrievalTimeout: (String verificationID){

      },
    );
  }

  // OTP 값 확인하고 메인페이지 가는 기능
  void verifyCode() async {
    try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId:verificationIDReceived, smsCode: optCodeController.text );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    // Firebase 인증 토큰 얻기
    String? firebaseToken = await userCredential.user!.getIdToken();
    String? uid = userCredential.user!.uid;
    String? tel = phoneController.text;
    print("Firebase 토큰: $firebaseToken");
    print("uid : $uid");
    print("tel : $tel");

    // Firebase 토큰을 백엔드 서버로 전송하여 JWT 토큰을 가져옴
    Map<String, dynamic>? signInResponse = await userProvider.getJwtTokenFromFirebaseToken(firebaseToken!, uid, tel);
    if (signInResponse != null) {
      String? id = signInResponse['id'];
      String? tel = signInResponse['tel'];
      String? token = signInResponse['token'];

      if (id != null && tel != null && token != null) {
        String jwtToken = '$id|$tel|$token'; // 예제에서 사용하는 방식으로 JWT 토큰 구성
        print("토큰 : $jwtToken");

        // 스토리지 저장 및 헤더에 토큰 값 할당 구현.!!!!!!!
        saveUserInfo('$id','$tel','$token');
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
    if (signInResponse == null) {
      // null  인 경우,  uid 와 tel 갖고 프로필페이지로 이동.
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileSettingPage(phoneNumber: '$tel', uid: '$uid')));
    }
    // print("토큰 : $jwtToken");
    print("파베로그인 성공!");
    } catch (e) {
    print("파베로그인 실패: $e");
    }

  }

  // 백엔드에서 사용자가 존재하는지 확인하는 함수
  Future<void> checkUserExistenceAndNavigate() async {
    final phoneNumber = phoneController.text; // 사용자가 입력한 전화번호
    final userExists = await UserProvider().checkUserExists(phoneNumber);
    // final userProvider = UserProvider();
    if (userExists) {
      // 이미 등록된 사용자인 경우
      print('가라 메인페이지');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()));
    } else {
      // await userProvider.registerUser(phoneNumber: phoneNumber, nickname: "", profileImg: "");
      // 백엔드에 등록되지 않은 사용자인 경우
      print('뉴멤버 환영');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원 가입을 해주세요!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JoinPage()));
                  // 기존 사용자 처리 로직 추가
                },
                child: Text('회원가입하러 이동'),
              ),
            ],
          );
        },
      );
    }
  }
}