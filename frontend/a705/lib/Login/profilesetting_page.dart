import 'package:a705/main_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/JoinDto.dart';
import '../providers/member_providers.dart';
import '../storage.dart';

class ProfileSettingPage extends StatefulWidget {
  final String phoneNumber; // 이전 페이지에서 전달된 전화번호
  final String uid;
  ProfileSettingPage({required this.phoneNumber,  required this.uid});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  String? _errorText;
  Color? _errorTextColor;
  final ImagePicker _picker = ImagePicker(); // ImagePicker 초기화
  File? _pickedFile; // 이미지 담을 변수 선언
  String? profileImg;
  final ImageProvider<Object> _profileImage = const AssetImage('assets/images/wagon_don.png');

  final TextEditingController _nicknameController = TextEditingController(); // 닉네임 입력 필드 컨트롤러

  final UserProvider _userProvider = UserProvider();

  SignUpDto  uploadSign = SignUpDto(
      tel: '',
    nickname: '',
    imageUrl: '',
    uid: '',
  );

  bool isNicknameValid(String nickname) {
    // 정규표현식을 사용하여 닉네임 유효성 검사
    final RegExp regex = RegExp(r'^[a-zA-Z가-힣0-9]{1,8}$');
    return regex.hasMatch(nickname);
  }


  Future<void> _checkNicknameAvailability() async {
    String nickname = _nicknameController.text;

    if (!isNicknameValid(nickname)) {
      setState(() {
        _errorText = '영문자, 한글로 8글자 이내 가능';
      });
      return;
    }

    String result = await _userProvider.checkNickname(nickname);

    setState(() {
      if (result == 'SUCCESS') {
        // 중복되지 않는 경우
        _errorText = '사용 가능한 닉네임입니다.';
        _errorTextColor = Colors.blue; // 파란색으로 변경
      } else if (result == 'FAIL') {
        // 중복된 경우
        _errorText = '이미 등록된 닉네임입니다.';
        _errorTextColor = Colors.red; // 빨간색으로 변경
      } else {
        // 서버 오류 또는 네트워크 오류
        _errorText = '서버 오류 또는 네트워크 오류가 발생했습니다.';
        _errorTextColor = Colors.red; // 빨간색으로 변경
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              children: [
                // 멘트
                const Row(
                  children: [
                    Text(
                      '프로필 사진과',
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
                      '닉네임을 설정해주세요.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                // 사진 변경
                Container(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: _pickedFile == null
                            ? _profileImage // 위에 선언 된 기본 이미지
                            : FileImage(_pickedFile!), // 선택한 이미지
                      ),
                      Positioned(
                        bottom: -10,
                        top: 100,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            _takePhoto(ImageSource.gallery);
                            // showModalBottomSheet(
                            //   context: context,
                            // builder: ((builder)=>Padding(
                            //   padding: EdgeInsets.only(
                            //     bottom: MediaQuery.of(context).viewInsets.bottom,
                            //   ),
                            //   child: Container(
                            //     height: 50,
                            //       margin: const EdgeInsets.all(20),
                            //       child: dialogSheet()),
                            // ) ),

                            // shape:  const RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.all(
                            //     // top: Radius.circular(30),
                            //     Radius.circular(50)
                            //   ),
                            // ),
                            //   isScrollControlled: false, //
                            // backgroundColor: Colors.transparent,
                            // );
                          },
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.yellow,
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height:30,),
                // 닉네임 & 중복체크
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: 70,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          child: TextField(
                            controller: _nicknameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                            ],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: '닉네임을 입력해 주세요.',
                              errorText: _errorText,
                              errorStyle: TextStyle(
                                color: _errorText != null && _errorText!.contains('사용 가능한')
                                    ? Colors.blue // 파란색으로 변경
                                    : Colors.red, // 빨간색으로 변경
                                fontSize: 12,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                // 에러 상태에서의 입력 칸 스타일 설정
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.red), // 에러 색상 설정
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width:10,),
                      SizedBox(
                        width: 100,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0xFFFFD954),
                            elevation: 0,
                          ),
                            onPressed: (){
                            // 닉네임 중복 체크 함수 작성
                              _checkNicknameAvailability();
                            },
                            child: const Text('중복 체크',
                              style: TextStyle(
                                fontSize: 15,
                                  color: Colors.black),),
                            ) ),
                    ],
                  ),

                ),
                const SizedBox(height: 20,),
                // 시작하기 버튼
                GestureDetector(
                  onTap: () async {
                    if (_errorText == '사용 가능한 닉네임입니다.') {
                      // _registerUser();
                      // 시작하기 버튼을 누를 때, uid, tel, img, nickname 으로 join 백엔드에 저장 보내고 응답으로 받은 값(id, tel, token)을 storage 에 저장.하고 홈페이지이동
                      uploadSign = SignUpDto(
                          tel: widget.phoneNumber,
                          nickname: _nicknameController.text,
                          imageUrl:  profileImg ?? 'assets/images/wagon_don.png',
                          uid: widget.uid);

                      try {
                        final responseBody = await _userProvider.signUp(uploadSign);

                        if (responseBody != null) {
                          final id = responseBody['id'];
                          final tel = responseBody['tel'];
                          final token = responseBody['token'];

                          // 데이터를 저장하기 위한 함수 호출
                          await saveUserInfo(id, tel, token);


                        } else {
                          // 응답이 null인 경우에 대한 처리
                          print('user 확인 응답이 안옴.');
                        }
                      } catch (e) {
                        // signUp 함수에서 예외가 발생한 경우 처리
                        print('프로필 설정 signUp 함수 예외');
                      }
                      // 이밑에 코드들은 지우지 마셈!!
                      //// 메인페이지에서 뒤로 가기 가능.
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const MainPage()),
                      // );
                      // 메인페이지 가면 뒤로가기 안됨 ( 기존 스택들 제거)
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) =>
                          const MainPage()), (Route<dynamic> route) => false);
                    }},
                  // },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      // ),
                      color: _errorText == '사용 가능한 닉네임입니다.' ? const Color(0xFFFFD954) : Colors.grey[300],
                      // color: _isNext() ?  const Color(0xFFFFD954) : Colors.grey[300], // 버튼 색상 변경
                    ),
                    child:  const Center(
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          // color: _isNext() ? Colors.black : Colors.grey,),
                      ),
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _pickedFile == null
                ? _profileImage // 위에 선언 된 기본 이미지
                : FileImage(_pickedFile!), // 선택한 이미지
          ),
          Positioned(
            bottom: -10,
            top: 100,
            right: 0,
            child: InkWell(
              onTap: () {
                _takePhoto(ImageSource.gallery);
                // showModalBottomSheet(
                //   context: context,
                  // builder: ((builder)=>Padding(
                  //   padding: EdgeInsets.only(
                  //     bottom: MediaQuery.of(context).viewInsets.bottom,
                  //   ),
                  //   child: Container(
                  //     height: 50,
                  //       margin: const EdgeInsets.all(20),
                  //       child: dialogSheet()),
                  // ) ),

                // shape:  const RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(
                //     // top: Radius.circular(30),
                //     Radius.circular(50)
                //   ),
                // ),
                //   isScrollControlled: false, //
                  // backgroundColor: Colors.transparent,
                // );
              },
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.yellow,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }



  // 갤러리에서 가져오기
  Future _takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // uploadImageToFirebase(pickedFile.path);
      String _path = "profile/image.jpg";
      File _file = File(pickedFile.path);
      await FirebaseStorage.instance.ref(_path).putFile(_file);
      final String _urlString =
      await FirebaseStorage.instance.ref(_path).getDownloadURL();
      setState(() {
        _pickedFile = File(pickedFile.path);
        profileImg = _urlString;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택 안 함');
      }
    }
  }

  Future<String> uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;
    final Reference storageReference = storage.ref().child('profile');

    final UploadTask uploadTask = storageReference.putFile(File(imagePath));

    // uploadTask.then((TaskSnapshot snapshot) async {
    //   // 업로드가 완료되면 이미지 URL을 얻어서 백엔드 서버로 전송하는 로직을 호출
    //   final imageUrl = await snapshot.ref.getDownloadURL();
    //   setState(() {
    //     profileImg = imageUrl;
    //   });
    // });
    final TaskSnapshot snapshot = await uploadTask;
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl; // 이미지 URL 반환
  }



  // 카메라에서 가져오기
  Future<void> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path);
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택 안 함');
      }
    }
  }




}
