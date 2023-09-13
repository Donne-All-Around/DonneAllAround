import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/start_page.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _phoneNumberController = TextEditingController(); // 전화번호 컨트롤러
  bool _isButtonEnabled = false; // 인증문자 받기 버튼 활성화 상태를 저장 하는 변수
  final _certificationController = TextEditingController(); // 인증번호 컨트롤러
  bool _isStartEnabled = false; // 시작하기 버튼 활성화 상태 저장 하는 변수
  // final GlobalKey certiKey = GlobalKey(); // 해당 위젯으로 스크롤 하기 위한 키 생성
  bool _isInputVisible = false; // 입력창의 가시성 상태 저장 변수
  int _remainingTime = 180; // 3분을 초 단위로 표현
  late Timer _timer;
  final FocusNode _certificationFocus = FocusNode(); // 자동 포커스 주기 위해
  var _buttonText = '인증문자 받기';

  bool _isValid(){
    final phoneNumber = _phoneNumberController.text.replaceAll('-', '');
    final isValid = phoneNumber.length == 11;  // 하이픈을 제거하고 11자리인지 확인
    setState(() {
      _isButtonEnabled = isValid; // 버튼 활성화 상태 업데이트
    });
    return isValid;
  }

  void _text() {
    if (_isValid()) {
      // 버튼을 누르면 타이머를 시작합니다.
      startTimer();
      // TODO: 인증문자 보내는 기능 구현
      // 인증번호를 받은 후에 버튼 비활성화
      // setState(() {  // 인증번호 받기 버튼 비활성화
      //   _isButtonEnabled = false;
      // });
    }
  }
  bool _isStart() {
    final certification = _certificationController.text;
    final isStart = certification.length == 5;
  setState(() {
    _isStartEnabled = isStart;
  });
    return isStart;
  }

  void _showInput() {
    setState(() {
      _isInputVisible = true;
    });
    _certificationFocus.requestFocus(); // 자동 커서
  }

  // @override
  // void initState() {  // 타이머 바로 작동
  //   super.initState();
  //   startTimer();
  // }
    void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel(); // 타이머 중지
        }
      });
    });
  }
  
  String formatRemainingTime(int seconds) {  // 타이머 형식
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  void dispose(){ // 컨트롤러 객체가 제거 될 때 변수에 할당 된 메모리를 해제
    _phoneNumberController.dispose();
    _certificationController.dispose();
    _timer.cancel(); // 페이지가 dispose될 때 타이머 종료
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
                    const Text(
                      '휴대폰 번호로',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
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
                    margin: const EdgeInsets.symmetric(horizontal: 30),
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
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          // borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: '휴대폰 번호 ( - 없이 숫자만 입력)',
                        labelStyle: const TextStyle(
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
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      if (_isValid()) {
                        // 버튼 누르면 입력창 보이도록 상태 업데이트
                        _showInput();
                        // 버튼을 활성화하고 이벤트를 처리합니다.(인증문자 보내는 기능 넣어야 함)
                        _text();
                        if(_buttonText == '인증문자 받기') {
                          _buttonText = '인증문자 재발송';
                        }
                        // Scrollable.ensureVisible(   // 클릭 시, certikey 위치로 스크롤 이동
                        //   certiKey.currentContext!,
                        //   duration: const Duration(seconds: 1),
                        // );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      height: 60,
                      width: double.infinity,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,// 버튼 테두리 색상 변경
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
                  ),
                  const SizedBox(height: 30,),
                    Column(
                      children: [
                        // if (_isInputVisible) // ture 일 때만 입력창 보이도록 조건부
                        //   TextButton(
                        //       onPressed: (){},
                        //       child: const Text(
                        //         '인증문자 재발송',
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //         ),
                        //       )),
                        // const SizedBox(height: 5,),
                        if (_isInputVisible) // ture 일 때만 입력창 보이도록 조건부
                        Container(
                          // key: certiKey, // 키 할당
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            focusNode: _isInputVisible ? _certificationFocus : null, // 입력창 나타나면 자동 포커스(삼항 연산자)
                            controller: _certificationController, // 인증번호 컨트롤러
                            keyboardType: TextInputType.number, // 키보드 숫자로 나타남
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자만!
                              LengthLimitingTextInputFormatter(5),
                              // 5자리 숫자만 입력받도록
                            ],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                // borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: '인증번호 입력',
                              suffixText: formatRemainingTime(_remainingTime),
                              suffixStyle: const TextStyle(color: Colors.red),
                              labelStyle: const TextStyle(
                                fontSize: 20,
                              ),
                              // contentPadding: EdgeInsets.all(20.0),
                            ),
                            onChanged: (text){
                              setState(() {
                                _isStartEnabled = _isStart();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),
                        // 인증번호 받기 버튼 등을 여기에 추가
                        if (_isInputVisible)
                        GestureDetector(
                          onTap: (){
                            if (_isStart()) {
                              // 버튼을 활성화하고 이벤트를 처리합니다.(인증문자 보내는 기능 넣어야 함)
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StartPage()),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                          ),
                        ),

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
