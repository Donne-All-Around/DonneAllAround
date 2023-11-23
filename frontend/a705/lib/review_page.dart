import 'package:a705/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 디코딩을 위해 추가
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  ScrollController _scrollController = ScrollController();
  String? baseUrl = dotenv.env['BASE_URL'];
  // 서버에서 임티후기 count 받아오기
  int badCount = 0;
  int goodCount = 0;
  int verygoodCount = 0;

  // 현재 선택된 버튼 (디폴트 : 판매)
  String selectedButton = '판매';

  // 판매 후기, 구매 후기 목록
  List<Map<String, dynamic>> buyReviews = [];
  List<Map<String, dynamic>> sellReviews = [];

  @override
  void initState() {
    super.initState();
    // initState에서 서버로 GET 요청을 보냅니다.
    fetchReviewCounts();
    fetchBuyReviews();
    fetchSellReviews();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the bottom, load more data
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadMoreData() async{
    List<Map<String, dynamic>> newItems;
    if(selectedButton == "판매"){
      int lastListIdx = sellReviews[sellReviews.length - 1]['id'];
      fetchMoreLoadSellReviews(lastListIdx);
    }else{
      int lastListIdx = buyReviews[buyReviews.length - 1]['id'];
      fetchMoreLoadBuyReviews(lastListIdx);
    }

  }

  void fetchMoreLoadBuyReviews(int lastListIdx) async {
    try {
      final url = Uri.parse(
          '$baseUrl/trade/review/list/buy?lastTradeId=$lastListIdx');
      final accessToken = getJwtAccessToken();

      http.Response response = await http.get(
          url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',},
      );

      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(response.body);
        final data = responseData['data']['tradeReviewList'];
        setState(() {
          buyReviews += List<Map<String, dynamic>>.from(data);
        });
        print('리뷰 요청 성공');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }

  } void fetchBuyReviews() async {
    try {
      final url = Uri.parse(
          '$baseUrl/trade/review/list/buy');
      final accessToken = getJwtAccessToken();

      http.Response response = await http.get(
          url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',},
      );

      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(response.body);
        final data = responseData['data']['tradeReviewList'];
        setState(() {
          buyReviews = List<Map<String, dynamic>>.from(data);
        });
        print('리뷰 요청 성공');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }

  void fetchMoreLoadSellReviews(int lastListIdx) async {
    try {
      final url = Uri.parse(
          '$baseUrl/trade/review/list/sell?lastTradeId=$lastListIdx');
      final accessToken = getJwtAccessToken();

      http.Response response = await http.get(
          url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',},
      );
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(response.body);
        final data = responseData['data']['tradeReviewList'];
        setState(() {
          sellReviews += List<Map<String, dynamic>>.from(data);
        });
        print('판매 서버 요청 성공');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }
  void fetchSellReviews() async {
    try {
      final url = Uri.parse(
          '$baseUrl/trade/review/list/sell');
      final accessToken = getJwtAccessToken();

      http.Response response = await http.get(
          url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',},
      );
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(response.body);
        final data = responseData['data']['tradeReviewList'];
        setState(() {
          sellReviews = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }

  void fetchReviewCounts() async {
    try {
      final url = Uri.parse('$baseUrl/trade/review/score');
      final accessToken = await getJwtAccessToken();

      http.Response response = await http.get(
          url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',},
      );
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
        print('갯수 서버 요청 성공');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }

  String _getDayOfWeekKorean(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }

  Widget _buildSellComment() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sellReviews.length,
      itemBuilder: (BuildContext context, int index) {
        final sellreview = sellReviews[index];
        final sellcreateTime = DateTime.parse(sellreview['createTime']);
        final sellformattedDate =
            '${sellcreateTime.year}년 ${sellcreateTime.month}월 ${sellcreateTime
            .day}일 ${_getDayOfWeekKorean(sellcreateTime.weekday)}';
        final sellreviewerNickname = sellreview['reviewerNickname'];
        final sellcomment = sellreview['comment'];

        return Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFFF2F2F2),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              sellformattedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ]
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/images/profile.jpg')
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                                sellreviewerNickname,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )
                            )
                        )
                      ]
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                          sellcomment,
                          style: const TextStyle(
                            fontSize: 16,
                          )
                      )
                  )
                ]
            )
        );
      }
    );
  }

  Widget _buildBuyComment() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: buyReviews.length,
      itemBuilder: (BuildContext context, int index) {
        final buyreview = buyReviews[index];
        final buycreateTime = DateTime.parse(buyreview['createTime']);
        final buyformattedDate =
            '${buycreateTime.year}년 ${buycreateTime.month}월 ${buycreateTime
            .day}일 ${_getDayOfWeekKorean(buycreateTime.weekday)}';
        final buyreviewerNickname = buyreview['reviewerNickname'];
        final buycomment = buyreview['comment'];

        return Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFFF2F2F2),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              buyformattedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ]
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/images/profile.jpg')
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                                buyreviewerNickname,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )
                            )
                        )
                      ]
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                          buycomment,
                          style: const TextStyle(
                            fontSize: 16,
                          )
                      )
                  )
                ]
            )
        );
      }
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


