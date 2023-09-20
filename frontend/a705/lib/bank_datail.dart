import 'package:flutter/material.dart';

class BankDetailPage extends StatefulWidget {
  const BankDetailPage({super.key});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
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
            title: const Text(
              '환율 검색',
                style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          ),
          body: SingleChildScrollView(
            child:Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: const Column(
                    children: [
                      // 멘트

                      SizedBox(height: 20,),
                      // 사진변경

                      // 닉네임 & 중복체크

                      // 시작하기 버튼
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
