import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  final ImagePicker _picker = ImagePicker(); // ImagePicker 초기화
  File? _pickedFile; // 이미지 담을 변수 선언
  final ImageProvider<Object> _profileImage = const AssetImage('assets/images/wagon_don.png');




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
                  height: 50,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          child: TextField(
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
                              hintText: '닉네임을 입력해 주세요.'
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
                            onPressed: (){},
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
                  onTap: (){
                    // if (_isNext()) {
                      // 버튼을 활성화하고 이벤트를 처리합니다.(인증문자 보내는 기능 넣어야 함)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileSettingPage()),
                      );
                    },
                  // },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      // ),
                      color: const Color(0xFFFFD954),
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
  Future<void> _takePhoto(ImageSource source) async {
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
