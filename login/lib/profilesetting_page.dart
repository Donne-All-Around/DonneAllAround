import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
            margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
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
                const SizedBox(height: 20,),
                // 사진 변경
                imageProfile(),
                // 닉네임 & 중복체크
                // 시작하기 버튼
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
                showModalBottomSheet(
                  context: context,
                  builder: ((builder)=>Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      height: 50,
                        margin: const EdgeInsets.all(20),
                        child: dialogSheet()),
                  ) ),
                shape:  const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    // top: Radius.circular(30),
                    Radius.circular(50)
                  ),
                ),
                  isScrollControlled: false, //
                  // backgroundColor: Colors.transparent,
                );
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

  // 사진선택 다이얼로그
  // Future<void> _showDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('사진 선택'),
  //         content: Container(
  //           width: double.maxFinite, // 최대 너비 설정
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextButton.icon(
  //                 icon: const Icon(
  //                   Icons.photo_camera_outlined,
  //                   size: 50,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context); // 다이얼로그 닫기
  //                   takePhoto(ImageSource.camera);
  //                 },
  //                 label: const Text(
  //                   'Camera',
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //               ),
  //               TextButton.icon(
  //                 icon: const Icon(
  //                   Icons.photo_library_outlined,
  //                   size: 50,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context); // 다이얼로그 닫기
  //                   _takePhoto(ImageSource.gallery);
  //                 },
  //                 label: const Text(
  //                   'Gallery',
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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

  Widget dialogSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width, // as BuildContext 제거
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 20,
      //   vertical: 20,
      // ),
      // width: double.infinity, // 화면 너비에 맞게 설정
      // decoration: const BoxDecoration(
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(30), // 가로로 긴 동그라미 모양
      //   ),
      //   color: Colors.white,
      // ),
      child: Column(
        children: [
          // const Text(
          //   '사진선택',
          //   style: TextStyle(
          //     fontSize: 20,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextButton.icon(
              //   icon: const Icon(Icons.photo_camera_outlined,
              //     size: 50,
              //   ),
              //   onPressed: () {
              //     takePhoto(ImageSource.camera);
              //   },
              //   label: const Text('Camera',
              //     style: TextStyle(fontSize: 20),),
              //
              // ),
              TextButton.icon(
                icon: const Icon(Icons.photo_library_outlined,
                  size: 20,
                ),
                onPressed: () {
                  _takePhoto(ImageSource.gallery);
                },
                label: const Text('Gallery',
                  style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
