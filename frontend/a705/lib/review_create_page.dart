import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 디코딩을 위해 추가

class ReviewCreatePage extends StatefulWidget {
  final int tradeID; // tradeID를 받아오기 위한 생성자 파라미터 추가

  const ReviewCreatePage({required this.tradeID, Key? key}) : super(key: key);

  @override
  State<ReviewCreatePage> createState() => ReviewCreatePageState();
}

class ReviewCreatePageState extends State<ReviewCreatePage> {

  bool isBadDonSelected = false;
  bool isGoodDonSelected = false;
  bool isBestDonSelected = false;

  String revieweeId = ''; //
  String revieweeNickname = '';

  void selectBadDon() {
    setState(() {
      isBadDonSelected = true;
      isGoodDonSelected = false;
      isBestDonSelected = false;
    });
  }

  void selectGoodDon() {
    setState(() {
      isBadDonSelected = false;
      isGoodDonSelected = true;
      isBestDonSelected = false;
    });
  }

  void selectBestDon() {
    setState(() {
      isBadDonSelected = false;
      isGoodDonSelected = false;
      isBestDonSelected = true;
    });
  }

  Map<String, dynamic>? tradeData; // 거래 정보를 저장할 변수

  @override
  void initState() {
    super.initState();
    fetchTradeData();
  }

  Future<void> fetchTradeData() async {
    final url = 'https://j9a705.p.ssafy.io/api/trade/detail/${widget.tradeID}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 서버 응답이 성공적일 때 데이터를 파싱하여 저장합니다.
        final parsedData = json.decode(response.body);
        final data = parsedData['data'];
        setState(() {
          tradeData = data;
        });
        // 리뷰 대상자의 아이디와 닉네임 설정
        final memberId = '1'; // 현재 사용자의 아이디
        final sellerId = tradeData?['sellerId'];
        final sellerNickname = tradeData?['sellerNickname'];
        final buyerId = tradeData?['buyerId'];
        final buyerNickname = tradeData?['buyerNickname'];

        if (sellerId == memberId && sellerNickname != null) {
          revieweeId = buyerId;
          revieweeNickname = buyerNickname;
        } else if (buyerId == memberId && buyerNickname != null) {
          revieweeId = sellerId;
          revieweeNickname = sellerNickname;
        }
        print('거래데이터 잘 받아옴');

      } else {
        // 오류 처리 로직 추가
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      // 오류 처리 로직 추가
      print('오류: $e');
    }
  }

  Future<void> _addReview() async {
    // 데이터 비어있는지 확인
    if (!isBadDonSelected && !isGoodDonSelected && !isBestDonSelected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                content : Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    '동전을 골라주세요!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('확인'),
                  )
                ]
            );
          }
      );
    } else {

      // 정보가 모두 입력되었을 떄 서버로 전송
      const memberId = '1'; // memberId 설정 (원하는 값으로 변경)
      final url = 'https://j9a705.p.ssafy.io/api/trade/review/${widget.tradeID}?memberId=$memberId';

      final requestData = {
        'revieweeId' : revieweeId,
        'score': isBadDonSelected ? -1 : isGoodDonSelected ? 1 : isBestDonSelected ? 2 : null,
        'comment' : commentController.text.isNotEmpty ? commentController.text : null,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          // 서버 응답이 성공적으로 왔을 때의 처리
          print('리뷰가 성공적으로 저장되었습니다.');
          Navigator.pop(context);

        } else {
          // 서버 응답이 실패했을 때의 처리
          print('서버 오류: ${response.statusCode}');
          // 오류 처리 로직 추가
        }
      } catch (e) {
        // 오류 발생 시 처리
        print('오류: $e');
        // 오류 처리 로직 추가
      }
    }
  }

  TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    // 페이지가 dispose 될 때 컨트롤러를 해제
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
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
              '거래 후기 남기기',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    width: double.infinity,
                    height: 60,
                    child: getSenderView(
                        ChatBubbleClipper6(type: BubbleType.sendBubble), context),
                  ),
                  SizedBox(height:10),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 2, 15, 10),
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              tradeData?['thumbnailImageUrl'],
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '거래한 상품',
                                      style: TextStyle(
                                        color: Colors.black54
                                      )
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                          AssetImage('assets/images/flag/${tradeData?['countryCode'] == 'KRW' ? 'KRW' : tradeData?['countryCode'] == 'USD' ? 'USDKRW' : 'USD${tradeData?['countryCode']}'}.png'),
                                          radius: 8,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${tradeData?['foreignCurrencyAmount']} ${tradeData?['countryCode']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          tradeData?['title'],
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ]
                            )
                          )
                        ),
                      ]
                    )
                  ),
                  SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Opacity(
                            opacity: isBadDonSelected ? 1.0 : 0.5,
                            child: GestureDetector(
                              onTap: selectBadDon,
                              child: Image.asset(
                                'assets/images/bad_don.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: isBadDonSelected ? 1.0 : 0.5, // Text 위젯에도 투명도 적용
                            child: const Text(
                              '별로예요.',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Opacity(
                            opacity: isGoodDonSelected ? 1.0 : 0.5,
                            child: GestureDetector(
                              onTap: selectGoodDon,
                              child: Image.asset(
                                'assets/images/good_don.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: isGoodDonSelected ? 1.0 : 0.5, // Text 위젯에도 투명도 적용
                            child: const Text(
                              '좋아요!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Opacity(
                            opacity: isBestDonSelected ? 1.0 : 0.5,
                            child: GestureDetector(
                              onTap: selectBestDon,
                              child: Image.asset(
                                'assets/images/best_don.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: isBestDonSelected ? 1.0 : 0.5, // Text 위젯에도 투명도 적용
                            child: const Text(
                              '최고예요!!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                  SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '후기 작성',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 20), // 텍스트 아래에 여백 추가
                  TextField(
                    controller: commentController,
                    maxLines: null, // 자동 줄 바꿈 활성화
                    keyboardType: TextInputType.multiline, // 여러 줄 입력 활성화
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      hintText: '후기를 작성해주세요...', // 힌트 텍스트
                      border: OutlineInputBorder(), // 텍스트 필드의 외곽선 스타일
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFFFD954),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          _addReview();
                        },
                        child: const Text(
                          '작성 완료',
                          style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)
                        )
                      )
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }

  getSenderView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    elevation: 0,
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.all(0),
    backGroundColor:const Color(0xFFFFD954),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit_note, // 원하는 아이콘을 선택하세요.
            color: Colors.blueGrey,
            size: 40,
          ),
          Text(
            revieweeNickname,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,),
          ),
          const Text(
            " 님과 거래는 어떠셨나요? ",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    ),
  );
}