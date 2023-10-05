import 'package:flutter/material.dart';
import 'trade_like_page.dart';
import 'sell_record_page.dart';
import 'buy_record_page.dart';
import 'withdrawal_page.dart';
import 'keyword_page.dart';
import 'exchange_record_page.dart';
import 'review_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int selectedScreen = 1; // 1은 '내 주머니', 2는 '내 계좌'

  Map<String, dynamic> userData = {};

  // 서버에 GET 요청을 보내는 함수
  Future<void> fetchData() async {
    final url = Uri.parse('https://j9a705.p.ssafy.io/api/member/info');
    const accessToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        final data = jsonData['data'];

        setState(() {
          userData = data; // 응답 데이터를 저장

          print(data);
          // "rating" 값을 정수로 변환

        });
      } else {
        print('요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (error) {
      print('에러 발생: $error');
      // 에러 처리를 원하는 방식으로 수행할 수 있습니다.
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> logout() async {
    final url = Uri.parse('https://j9a705.p.ssafy.io/api/member/logout');
    const accessToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

    final refreshToken = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2OTc2NDYyNTF9.SHw9gvdoSj4i9wmYYcKxaY4B5xEpOGv9Onq6TLpNJMo';

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'refreshToken': refreshToken}),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final message = jsonData['message'];
        // 로그아웃 성공 메시지 처리
        print('로그아웃 성공');

        // 로그아웃 후 필요한 작업을 수행하실 수 있습니다.
      } else {
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (error) {
      print('에러 발생: $error');
      // 에러 처리를 원하는 방식으로 수행할 수 있습니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD954),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const SizedBox(height: 35.0),
                      // 상단부분: 프로필 사진과 닉네임
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 25.0),
                            Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      userData['imageUrl'], // 이미지 URL을 여기에 넣으세요.
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      // 프로필 수정 페이지로 이동하는 로직 추가.
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 12,
                                      )
                                    )
                                  )
                                )
                              ]
                            ),
                            const SizedBox(width: 25.0),
                            Text(
                              // '닉네임',
                              userData['nickname'],
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 중단 부분 : 버튼들
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 105.0,
                              height: 40.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  // '내 주머니' 버튼 클릭 시 동작
                                  setState(() {
                                    selectedScreen = 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedScreen == 1 ? const Color(0xFFE0AE00) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  '내 점수',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: selectedScreen == 1 ? Colors.white : const Color(0xFFA6A6A6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Container(
                              width: 105.0,
                              height: 40.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  // '내 계좌' 버튼 클릭 시 동작
                                  setState(() {
                                    selectedScreen = 2;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedScreen == 2 ? const Color(0xFFE0AE00) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  '내 계좌',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: selectedScreen == 2 ? Colors.white : const Color(0xFFA6A6A6),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selectedScreen == 1)
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            width: 360.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: (360.0 - 270.0) / 2, // 수평 중앙 정렬
                                  top: (80.0 - 30.0) / 2,   // 수직 중앙 정렬
                                  width: 270.0,
                                  height: 30.0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFCE51), // 배경색
                                      borderRadius: BorderRadius.circular(30.0), // BorderRadius 설정
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: (360.0 - 270.0) / 2, // 수평 중앙 정렬
                                  top: (80.0 - 30.0) / 2,                   // 수직 중앙 정렬
                                  width: 270.0 * userData['rating'] / 1000,
                                  // width: 270.0 * 400 / 1000,
                                  height: 30.0,
                                  child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3B14E), // 배경색
                                        borderRadius: BorderRadius.circular(30.0), // BorderRadius 설정
                                      ),
                                  ),
                                ),
                                Positioned(
                                  left: (360.0 - 100.0) / 2,
                                  top: (80.0 - 30.0) / 2,
                                  width: 100,
                                  height: 30,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child : Text(
                                      '${userData['rating']}/1000',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                      if (selectedScreen == 2)
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            width: 360.0,
                            height: 80.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Text(
                                    '${userData['point']}원',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  onPressed: () {
                                    // '>' 버튼 클릭 시 동작
                                  },
                                ),
                              ],
                            ),
                          )
                        )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  height: 210,
                  width: 360,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "나의 거래",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Inter",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TradeLikePage()));
                        },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.favorite_border,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "관심 목록",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SellRecordPage()));
                          },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.receipt,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                    "판매 내역",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter",
                                      fontSize: 15.0,
                                    )
                                )
                              ]
                          )
                        )
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BuyRecordPage()));
                          },
                        child: Container(
                          height:35.0,
                          child: const Row (
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.shopping_bag,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "구매 내역",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                )
                              )
                            ]
                          )
                        )
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReviewPage()));
                        },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.fact_check,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "나의 후기",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                )
                              )
                            ]
                          )
                        )
                      )
                    ]
                  )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  height: 105,
                  width: 360,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "나의 환전",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Inter",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExchangeRecordPage()));
                        },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.edit,
                              ),
                              SizedBox(width:8.0),
                              Text(
                                "환전 기록",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0
                                )
                              )
                            ]
                          )
                        )
                      )
                    ]
                  )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  height: 105,
                  width: 360,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment:Alignment.centerLeft,
                        child: Text(
                          "나의 키워드",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Inter",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => KeywordPage()));
                        },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.person,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "거래",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                )
                              )
                            ]
                          ),
                        ),
                      ),
                    ]
                  )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  height: 140,
                  width: 360,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "사용자 설정",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Inter",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  width: 350.0,
                                  height: 250.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            '로그아웃',
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(48.0, 0, 16.0, 8.0),
                                          child: Text(
                                            '다시 로그인 하실 때',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Inter',
                                            )
                                          ),
                                        )
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(48.0, 0, 16.0, 8.0),
                                          child: Text(
                                            '전화번호 인증이 필요합니다.',
                                            style: TextStyle(
                                             fontSize: 16.0,
                                             fontFamily: 'Inter',
                                            )
                                          )
                                        )
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(48.0, 0, 16.0, 8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '정말 ',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Inter',
                                                )
                                              ),
                                              Text(
                                                '로그아웃',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Inter',
                                                  color: Colors.red,
                                                )
                                              ),
                                              Text(
                                                ' 하시겠습니까?',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Inter',
                                                )
                                              )
                                            ]
                                          )
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                fixedSize: const Size(105.0, 40.0),
                                              ),
                                              child: const Text(
                                                '취소',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),
                                            const SizedBox(width: 30.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                logout();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFFD954),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                fixedSize: const Size(105.0, 40.0),
                                              ),
                                              child: const Text(
                                                '로그아웃',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),
                                          ]
                                        )
                                      )
                                    ]
                                  )
                                )
                              );
                            }
                          );
                        },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.logout
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "로그아웃",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0
                                )
                              )
                            ]
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WithdrawalPage()));
                        },
                        child: Container(
                          height: 35.0,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "회원 탈퇴",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0
                                )
                              )
                            ]
                          )
                        )
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}
