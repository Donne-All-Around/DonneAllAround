import 'package:flutter/material.dart';
import 'package:a705/transaction_detail_page.dart';
import 'package:intl/intl.dart';
import 'review_create_page.dart';
import 'dart:convert'; // JSON 파싱을 위해 추가
import 'package:http/http.dart' as http;

class SellRecordPage extends StatefulWidget {
  const SellRecordPage({super.key});

  @override
  State<SellRecordPage> createState() => SellRecordPageState();
}

class SellRecordPageState extends State<SellRecordPage> {

  // 현재 선택된 버튼 (디폴트 : 판매)
  String selectedButton = '판매 중';

  ScrollController _scrollController = ScrollController();


  List<Map<String, dynamic>> waitList = [];
  List<Map<String, dynamic>> completeList = [];

  String formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;

    return '$year년 $month월 $day일';
  }

  @override
  void initState() {
    super.initState();
    // initState에서 서버로 GET 요청을 보냅니다.
    fetchWaitHistory();
    fetchCompleteHistory();
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
    if(selectedButton == "판매 중"){
      int lastListIdx = waitList[waitList.length - 1]['id'];
      fetchMoreLoadWaitHistory(lastListIdx);
    }else{
      int lastListIdx = completeList[completeList.length - 1]['id'];
      fetchMoreLoadCompleteHistory(lastListIdx);
    }
  }

  void fetchMoreLoadWaitHistory(int lastListIdx ) async {
    try {
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/history/sell/sale?lastTradeId=$lastListIdx');

      const accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(responseBody);
        final data = responseData['data'];
        final tradeListData = data['tradeList'];

        setState(() {
          waitList += List<Map<String, dynamic>>.from(tradeListData);
        });
        print('판매중내역 잘 들어온다');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }
  void fetchWaitHistory() async {
    try {
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/history/sell/sale');

      const accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(responseBody);
        final data = responseData['data'];
        final tradeListData = data['tradeList'];

        setState(() {
          waitList = List<Map<String, dynamic>>.from(tradeListData);
        });
        print('판매중내역 잘 들어온다');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }

  void fetchCompleteHistory() async {
    try {
       // 원하는 회원 ID를 여기에 넣어주세요.
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/history/sell/complete');
      const accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(responseBody);
        final data = responseData['data'];
        final tradeListData = data['tradeList'];

        setState(() {
          completeList = List<Map<String, dynamic>>.from(tradeListData);
        });
        print('판완내역 잘 들어온다');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
  }void fetchMoreLoadCompleteHistory(int lastListIdx) async {
    try {
       // 원하는 회원 ID를 여기에 넣어주세요.
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/history/sell/complete?lastTradeId=$lastListIdx');
      const accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(responseBody);
        final data = responseData['data'];
        final tradeListData = data['tradeList'];

        setState(() {
          completeList += List<Map<String, dynamic>>.from(tradeListData);
        });
        print('판완내역 잘 들어온다');
      } else {
        // 서버 응답이 실패인 경우
        print('서버 요청 실패 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 요청 중 오류 발생: $e');
    }
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
                '판매 내역',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
            ),
            centerTitle: true,
          ),
          body : Stack(children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedButton ='판매 중';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor : selectedButton == '판매 중' ? const Color(0xFFFFD954) : Colors.white,
                                  foregroundColor : selectedButton == '판매 중' ? const Color(0xFF3D2F00) : const Color(0xFF6C6A6A),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: Color(0xFF6C6A6A),
                                    ),
                                  ),
                                  minimumSize: const Size(80, 35)
                              ),
                              child: const Text('판매 중'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButton ='거래 완료';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor : selectedButton == '거래 완료' ? const Color(0xFFFFD954) : Colors.white,
                                    foregroundColor : selectedButton == '거래 완료' ? const Color(0xFF3D2F00) : const Color(0xFF6C6A6A),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Color(0xFF6C6A6A),
                                        )
                                    ),
                                    minimumSize: const Size(80, 35)
                                ),
                                child: const Text('거래 완료')
                            ),
                          ]
                      )
                  ),
                  // 상태에 따라 표시되는 내용
                  const SizedBox(height: 20),
                  selectedButton == '판매 중'
                      ? _buildSellWaitListView()
                      : _buildSellCompleteListView(),
                ]
              )
            )
          ])
        )
    );
  }

  Widget _buildSellWaitListView() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: waitList.length,
          itemBuilder: (BuildContext context, int index) {
            final wait = waitList[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TransactionDetailPage(1);
                  },
                ));
              },
              child: Container(
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
                    ]),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            formatDate(wait['createTime']),
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              wait['thumbnailImageUrl'],
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            // height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        wait['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                ),
                                const SizedBox(height:3),
                                Row(
                                  children: [
                                    Text(
                                      wait['type'] == 'DIRECT'
                                          ? '${wait['administrativeArea']} ${wait['subLocality']} ${wait['thoroughfare']}'
                                          : '택배거래',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(height:3),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                      AssetImage('assets/images/flag/${wait['countryCode'] == 'KRW' ? 'KRW' : wait['countryCode'] == 'USD' ? 'USDKRW' : 'USD${wait['countryCode']}'}.png'),
                                      radius: 8,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${NumberFormat("#,##0").format(wait['foreignCurrencyAmount'])} ${wait['countryCode']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height:3),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.fromLTRB(3, 2, 3, 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD954),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        wait['status'] == 'WAIT' ? '판매중' : wait['status'] == 'PROGRESS' ? '예약중' : '',
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${NumberFormat("#,##0").format(wait['koreanWonAmount'])} 원',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          })
    );
  }



  Widget _buildSellCompleteListView() {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: completeList.length,
          itemBuilder: (BuildContext context, int index) {
            final complete = completeList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TransactionDetailPage(1);
                  },
                ));
              },
              child: Container(
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
                    ]),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            formatDate(complete['createTime']),
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              complete['thumbnailImageUrl'],
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            // height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        complete['title'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                ),
                                const SizedBox(height:3),
                                Row(
                                  children: [
                                    Text(
                                      complete['type'] == 'DIRECT'
                                          ? '${complete['administrativeArea']} ${complete['subLocality']} ${complete['thoroughfare']}'
                                          : '택배거래',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(height:3),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                      AssetImage('assets/images/flag/${complete['countryCode'] == 'KRW' ? 'KRW' : complete['countryCode'] == 'USD' ? 'USDKRW' : 'USD${complete['countryCode']}'}.png'),
                                      radius: 8,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${NumberFormat("#,##0").format(complete['foreignCurrencyAmount'])} ${complete['countryCode']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height:3),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.fromLTRB(3, 2, 3, 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD954),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Text('판매완료'),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${NumberFormat("#,##0").format(complete['koreanWonAmount'])}원',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 350,
                      height: 35,
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                      child: complete['hasReview'] != false
                          ? null // false 일 때는 아무것도 반환하지 않음
                          : ElevatedButton(
                        onPressed: () {
                          final tradeID = complete['id'];
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewCreatePage(tradeID: tradeID)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD954),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          '후기 작성',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
    );
  }
}

