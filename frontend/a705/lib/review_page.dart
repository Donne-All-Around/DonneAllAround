import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 디코딩을 위해 추가




class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  // 서버에서 임티후기 count 받아오기
  int badCount = 0;
  int goodCount = 0;
  int verygoodCount = 0;

  // 현재 선택된 버튼 (디폴트 : 판매)
  String selectedButton = '판매';

  void _handleDelete() {
    // 삭제 작업 코드
  }

  @override
  void initState() {
    super.initState();
    // initState에서 서버로 GET 요청을 보냅니다.
    fetchReviewCounts();
  }

  void fetchReviewCounts() async {
    try {
      const memberId = '1'; // 원하는 회원 ID를 여기에 넣어주세요.
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/review/score?memberId=$memberId');

      http.Response response = await http.get(url);
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(response.body);
        final data = responseData['data'];
        setState(() {
          badCount = data['bad'];
          goodCount = data['good'];
          verygoodCount = data['veryGood'];
        });
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }

  Widget _buildSellComment() {
    return Container(
      width : 350,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF2F2F2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2022년 9월 20일 수요일',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('삭제하기'),
                      )
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'delete') {
                      _handleDelete();
                    }
                  }
                )
              ]
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profile.jpg')
                )
              ),
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: const Text(
                  '닉네임',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                )
              )
            ]
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Text(
              '코멘트 내용 from 서버',
              style: TextStyle(
                fontSize: 16,
              )
            )
          )
        ]
      )
    );
  }

  Widget _buildBuyComment() {
    return Container(
        width : 350,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFFF2F2F2),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                          '2022년 9월 22일 수요일',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.black,
                          ),
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('삭제하기'),
                              )
                            ];
                          },
                          onSelected: (value) {
                            if (value == 'delete') {
                              _handleDelete();
                            }
                          }
                      )
                    ]
                ),
              ),
              const SizedBox(height: 5),
              Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/images/profile.jpg')
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: const Text(
                            '닉네임',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )
                        )
                    )
                  ]
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: const Text(
                      '코멘트 내용 from 서버',
                      style: TextStyle(
                        fontSize: 16,
                      )
                  )
              )
            ]
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }
          ),
          elevation: 0,
          title: const Text(
            '나의 후기',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/bad_don.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        '$badCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/good_don.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        '$goodCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/best_don.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        '$verygoodCount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                ]
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton ='판매';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor : selectedButton == '판매' ? const Color(0xFFFFD954) : Colors.white,
                        foregroundColor : selectedButton == '판매' ? const Color(0xFF3D2F00) : const Color(0xFF6C6A6A),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Color(0xFF6C6A6A),
                          ),
                        ),
                        minimumSize: const Size(80, 35)
                      ),
                      child: const Text('판매'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton ='구매';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor : selectedButton == '구매' ? const Color(0xFFFFD954) : Colors.white,
                        foregroundColor : selectedButton == '구매' ? const Color(0xFF3D2F00) : const Color(0xFF6C6A6A),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Color(0xFF6C6A6A),
                          )
                        ),
                        minimumSize: const Size(80, 35)
                      ),
                      child: const Text('구매')
                    ),
                  ]
                )
              ),
              // 상태에 따라 표시되는 내용
              const SizedBox(height: 20),
              selectedButton == '판매'
                  ? _buildSellComment()
                  : _buildBuyComment(),
            ]
          )
        )
      ),
    );
  }
}
