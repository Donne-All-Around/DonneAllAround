import 'package:flutter/material.dart'; //기본 import
import 'package:a705/Login/login_page.dart'; // login_page import
import 'package:a705/Login/join_page.dart'; // join_page import

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context){
    return   SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset : false,
         body: SingleChildScrollView(
           child: Center(
            child: Column(
              children:[
                const SizedBox(height: 100,), // 위에 여백
                // 시작페이지 서비스명
                const Text(
                '돈네 한 바퀴',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),
                ),
                const Text(
                  '동네에서 가볍게, 내 손안의 은행',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.grey),
                ),
                // 로고 이미지
                Container(
                  child: Image.asset('assets/images/good_don.png'),
                ),
                //로그인 버튼
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Color(0xFFFFD954),
                    ),
                    child: const Center(
                      child: Text(
                        '로그인',
                        style: TextStyle(fontSize:25,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,), // 여백
                // 회원가입버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '아직 계정이 없으신가요?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const JoinPage()),
                            );
                          },
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),),
                    ],
                  ),
              ],
            ),

        ),
         )
    ),
      ),
    );
  }

}

