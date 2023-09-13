import 'package:flutter/material.dart';
import 'package:login/location_information.dart';
import 'package:login/personal_information.dart';
import 'package:login/profile1_page.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  var _isCheckedAll = false; // 전체
  var _isChecked1 = false; // 이용약관
  var _isChecked2 = false; // 위치정보
  // bool _isNextEnabled = false; // 다음 버튼 활성화 상태 저장 변수


  bool _isNext() {
    return _isChecked1 && _isChecked2;
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
            margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Column(
              children: [
            // 멘트
            Row(
            children:[
            Text(
            '돈네 한 바퀴',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.yellow[600],
              ),
            ),
            const Text(
              '가',
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
                    '처음이신가요?',
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
                    '약관 동의',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.yellow[600],
                    ),
                  ),
                  const Text(
                    '가 필요해요!',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),

            ],
          ),
          const SizedBox(height: 20,),
          // 이미지
              Container(
                child: Image.asset(
                  'assets/images/wagon_don.png', width: 200, height: 200,),
              ),
              const SizedBox(height: 20,),
              // 약관들
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black38),
                ),
                child: Row(
                  children: [
                    Checkbox(
                        value: _isCheckedAll,
                        onChanged: (value) {
                          setState(() {
                            _isCheckedAll = value!;
                            _isChecked1 = value!;
                            _isChecked2 = value!;
                          });
                        }),
                    const SizedBox(width: 10,),
                    const Text(
                      '약관 전체 동의',
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                  ],
                ),
              ),
                const SizedBox(height: 10,),
                Container( height:1.0,
                  width:500.0,
                  color:Colors.grey,),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                          value: _isChecked1,
                          onChanged: (value) {
                            setState(() {
                              _isChecked1 = value!;
                            });
                          }),
                      const SizedBox(width: 10,),
                      const Text(
                        '개인 정보 수집 및 이용 동의',
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      const SizedBox(width: 30,),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PersonalPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: Row(
                    children: [
                      Checkbox(value: _isChecked2,
                          onChanged: (value) {
                            setState(() {
                              _isChecked2 = value!;
                            });
                          }),
                      const SizedBox(width: 10,),
                      const Text(
                        '위치 정보 이용 동의',
                        style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 80,),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocationPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 20,),
            // 다음 버튼
                GestureDetector(
                  onTap: (){
                    if (_isNext()) {
                      // 버튼을 활성화하고 이벤트를 처리합니다.(인증문자 보내는 기능 넣어야 함)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    }
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      // ),
                      color: _isNext() ?  const Color(0xFFFFD954) : Colors.grey[300], // 버튼 색상 변경
                    ),
                    child:  Center(
                      child: Text(
                        '다  음',
                        style: TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.bold,
                          color: _isNext() ? Colors.black : Colors.grey,),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),);
  }

}