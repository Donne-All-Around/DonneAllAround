import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _phoneNumberController = TextEditingController();
  bool _isButtonEnabled = false; // 버튼 활성화 상태를 저장 하는 변수
  bool _showVerification = false; // 버튼 클릭시 스크롤
  TextEditingController _verificationController = TextEditingController(); // 인증번호 입력칸 컨트롤러

  bool _isValid(){
    final phoneNumber = _phoneNumberController.text.replaceAll('-', '');
    final isValid = phoneNumber.length == 11;  // 하이픈을 제거하고 11자리인지 확인
    setState(() {
      _isButtonEnabled = isValid; // 버튼 활성화 상태 업데이트
    });
    return isValid;
  }

  void _text() {
    // 인증문자 받기
    setState(() {
      _showVerification = true;
    });
  }

  @override
  void dispose(){
    _phoneNumberController.dispose();
    _verificationController.dispose(); // 컨트롤러 해제
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
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (!_showVerification)
                    const Text(
                      '휴대폰 번호로',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  if (!_showVerification)
                    const Text(
                      '로그인 해주세요!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _phoneNumberController,// 전화번호 입력칸
                      keyboardType: TextInputType.number, // 키보드 숫자로 나타남
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, //숫자만!
                        NumberFormatter(), // 자동하이픈
                        LengthLimitingTextInputFormatter(13),
                        //13자리만 입력받도록 하이픈 2개+숫자 11개
                      ],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(
                          // borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: '휴대폰 번호 ( - 없이 숫자만 입력)',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          // textAlign: TextAlign.center,
                        ),
                        // contentPadding: EdgeInsets.all(20.0),
                      ),
                      // 입력값 변할 때마다 setState 호출해서 위젯 업데이트 (disable 설정 반영위해)
                      onChanged: (text){
                        setState(() {
                          _isButtonEnabled = _isValid(); // 입력값이 변경될 때마다 검증 수행
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      if (_isValid()) {
                        // 버튼을 활성화하고 이벤트를 처리합니다.
                        _text();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 50,
                      width: double.infinity,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                        ),
                        color: _isButtonEnabled ? Colors.white : Colors.grey[400], // 버튼 색상 변경
                      ),
                      child: const Center(
                        child: Text(
                          '인증문자 받기',
                          style: TextStyle(fontSize:25,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  if (_showVerification) // 인증번호 입력 관련 위젯 표시
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: _verificationController, // 인증번호 입력칸
                            keyboardType: TextInputType.number, // 키보드 숫자로 나타남
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자만!
                              LengthLimitingTextInputFormatter(6),
                              // 6자리 숫자만 입력받도록
                            ],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                // borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: '인증번호 입력',
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              // contentPadding: EdgeInsets.all(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        // 인증번호 받기 버튼 등을 여기에 추가
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
