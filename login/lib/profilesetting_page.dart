import 'package:flutter/material.dart';

class ProfileSettingPage extends StatefulWidget {
  const  ProfileSettingPage({super.key});

  @override
  State< ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State< ProfileSettingPage> {
  @override
  Widget build(BuildContext context){
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
            child: const Column(
              children: [
                // 멘트
                Row(
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
                Row(
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
                SizedBox(height: 20,),
                // 사진변경

                // 닉네임 & 중복체크

                // 시작하기 버튼
              ],
            ),
          ),
        ),
      ),
    );
  }

}