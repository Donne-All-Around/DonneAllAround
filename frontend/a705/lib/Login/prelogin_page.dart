import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_page.dart';

class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  @override
  State<PreLoginPage> createState() => _PreLoginPageState();

}

class _PreLoginPageState extends State<PreLoginPage> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController optCodeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIDReceived = "";

  bool otpCodeVisible = false;

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
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Column(
                    children: [
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(

                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        verifyNumber();
                      },
                          child: Text(otpCodeVisible == true ? "인증문자 재발송" : "인증문자 받기")),
                      Visibility(
                        visible: otpCodeVisible,
                        child: TextField(
                          controller: optCodeController,
                          decoration: const InputDecoration(

                          ),
                        ),
                      ),
                      Visibility(
                        visible: otpCodeVisible,
                        child: ElevatedButton(onPressed: (){
                          verifyCode();
                        },
                            child: const Text('시작하기')),
                      ),
                    ],
                  )
              ),

            ),

          ),

        )
    );
  }

  void verifyNumber(){
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
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
          setState(() {
            
          });
      },
      codeAutoRetrievalTimeout: (String verificationID){

      },
    );
  }

  void verifyCode() async {

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId:verificationIDReceived, smsCode: optCodeController.text );
    await auth.signInWithCredential(credential).then((value){
      print("로그인 성공!");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
  }
}