import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_page.dart';


class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  @override
  State<PreLoginPage> createState() => _PreLoginPageState();

}

class _PreLoginPageState extends State<PreLoginPage> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  late String _verificationId;
  bool _isButtonEnabled = false; // 인증문자 받기 버튼 활성화 상태를 저장 하는 변수
  var _buttonText = '인증문자 받기';
  bool _isStartEnabled = false; // 시작하기 버튼 활성화 상태 저장 하는 변수


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
              child: Form(
                key: _key,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                      Column(
                        children: [
                          phoneNumberInput(),
                          const SizedBox(height: 10,),
                          submitButton(),
                          const SizedBox(height: 20,),
                          smsCodeInput(),
                          const SizedBox(height: 10,),
                          verifyButton(),

                        ],
                      ),
                    ],
                  ),
                ),
              ),

            ),

          ),

        )
    );
  }


  TextFormField phoneNumberInput() {
    return TextFormField(
      controller: _phoneController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: BorderSide(color: Colors.black),
        ),
        hintText: '휴대폰 번호 ( - 없이 숫자만 입력)',
        hintStyle: const TextStyle(fontSize: 13),
        labelStyle: const TextStyle(
          fontSize: 20,
          // textAlign: TextAlign.center,
        ),
        // contentPadding: EdgeInsets.all(20.0),
      ),
    );
  }

  TextFormField smsCodeInput() {
    return TextFormField(
      controller: _smsCodeController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: BorderSide(color: Colors.black),
        ),
        hintText: '인증번호 입력',
        // suffixText: formatRemainingTime(_remainingTime),
        // suffixStyle: const TextStyle(color: Colors.red),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        // contentPadding: EdgeInsets.all(20.0),
      ),
    );
  }

  ElevatedButton submitButton(){
    return ElevatedButton(
        onPressed: () async {
          if (_key.currentState!.validate()) {
            FirebaseAuth auth = FirebaseAuth.instance;
            await auth.verifyPhoneNumber(
              phoneNumber: _phoneController.text,
                verificationCompleted: (PhoneAuthCredential credential) async {

                await auth
                    .signInWithCredential(credential)
                    .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage())));
                },
                verificationFailed: (FirebaseAuthException e) {
                if (e.code == 'invalid-phone-number') {
                  print('유효하지 않은 번호임');
                }
                },
                codeSent: (String verificationId, forceResendingToken) async {
                String smsCode = _smsCodeController.text;
                setState(() {
                  _buttonText = '인증문자 재발송';
                  _verificationId = verificationId;
                });
                },
                codeAutoRetrievalTimeout: (verificationId){
                print('시간초과');
                });
          }
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isButtonEnabled ? Colors.white : Colors.grey[300],
        elevation: 0,
      ),
      child: Container(
      // margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      height: 60,
      width: double.infinity,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.transparent,// 버튼 테두리 색상 변경
        ),
        color: _isButtonEnabled ? Colors.white : Colors.grey[300], // 버튼 색상 변경
      ),
      child: Center(
        child: Text(
          _buttonText,
          style: TextStyle(
            fontSize:25,
            fontWeight: FontWeight.bold,
            color: _isButtonEnabled ? Colors.black : Colors.grey, // 버튼 텍스트 색상 변경),
          ),
        ),
      ),
    ),
    );
  }

  ElevatedButton verifyButton() {
    return ElevatedButton(
        onPressed: () async {
          FirebaseAuth auth = FirebaseAuth.instance;
          
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: _verificationId,

              smsCode: _smsCodeController.text);
          
          await auth
              .signInWithCredential(credential)
              .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage())));

        },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isButtonEnabled ? Colors.white : Colors.grey[300],
        elevation: 0,
      ),
        child:Container(
          // margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          height: 60,
          width: double.infinity,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(
            // ),
            color: _isStartEnabled ?  const Color(0xFFFFD954) : Colors.grey[300], // 버튼 색상 변경
          ),
          child:  Center(
            child: Text(
              '시작하기',
              style: TextStyle(
                fontSize:25,
                fontWeight: FontWeight.bold,
                color: _isStartEnabled ? Colors.black : Colors.grey,),
            ),
          ),
        ),);
  }

}