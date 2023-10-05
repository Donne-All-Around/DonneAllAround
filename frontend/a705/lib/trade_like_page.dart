import 'package:flutter/material.dart';
import 'package:a705/transaction_detail_page.dart';
import 'dart:convert'; // JSON 파싱을 위해 추가
import 'package:http/http.dart' as http;

class TradeLikePage extends StatefulWidget {
  const TradeLikePage({super.key});

  @override
  State<TradeLikePage> createState() => TradeLikePageState();
}

class TradeLikePageState extends State<TradeLikePage> {

  List<Map<String, dynamic>> tradeList = [];

  @override
  void initState() {
    super.initState();
    // initState에서 서버로 GET 요청을 보냅니다.
    fetchTradeLikeHistory();
  }

  void fetchTradeLikeHistory() async {
    try {
      const memberId = '1'; // 원하는 회원 ID를 여기에 넣어주세요.
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/like?memberId=$memberId');

      http.Response response = await http.get(url);
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(responseBody);
        final data = responseData['data'];
        final tradeListData = data['tradeList'];

        setState(() {
          tradeList = List<Map<String, dynamic>>.from(tradeListData);
        });
        print('관심목록 잘 들어온다');
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
            '관심 목록',
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
                Expanded(child: ListViewBuilder(tradeLikePageState: this)),
              ]
            )
          )
        ])
      )
    );
  }
}

class ListViewBuilder extends StatefulWidget {
  final TradeLikePageState tradeLikePageState;

  const ListViewBuilder({Key? key, required this.tradeLikePageState}) : super(key: key);

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {

  String formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;

    return '$year년 $month월 $day일';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.tradeLikePageState.tradeList.length,
        itemBuilder: (BuildContext context, int index) {
          final trade = widget.tradeLikePageState.tradeList[index];

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
                          formatDate(trade['createTime']),
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
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              trade['thumbnailImageUrl'],
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
                                    trade['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child : IconButton(
                                      icon : const Icon(Icons.favorite, color: Colors.red),
                                      onPressed: () async {
                                        // tradeId와 memberId 설정
                                        final tradeId = trade['id']; // trade['id'] 또는 다른 필드에 해당하는 값으로 변경
                                        const memberId = '1'; // 사용자의 memberId로 변경

                                        // DELETE 요청 보내기
                                        final deleteUrl = 'https://j9a705.p.ssafy.io/api/trade/$tradeId/unlike?memberId=$memberId';

                                        try {
                                          final response = await http.delete(
                                            Uri.parse(deleteUrl),
                                            headers: {
                                              "Accept-Charset": "utf-8", // 문자 인코딩을 UTF-8로 설정
                                            },
                                          );

                                          if (response.statusCode == 200) {
                                            setState(() {
                                              // tradeList에서 해당 항목 제거
                                              widget.tradeLikePageState.tradeList.removeWhere((element) => element['id'] == tradeId);
                                            });
                                            print('관심목록 삭제 성공');
                                          } else {
                                            // 삭제 실패 시의 처리
                                            print('관심목록 제거 실패: ${response.statusCode}');
                                            // 실패한 경우 사용자에게 알림을 표시하는 등의 처리 추가 가능
                                          }
                                        } catch (e) {
                                          // 오류 처리
                                          print('오류: $e');
                                          // 오류 발생 시 사용자에게 알림을 표시하는 등의 처리 추가 가능
                                        }
                                      },
                                      iconSize: 30,
                                    )
                                  )
                                ]
                              ),
                              Row(
                                children: [
                                  Text(
                              '${trade['administrativeArea']} ${trade['subLocality']} ${trade['thoroughfare']}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                    AssetImage('assets/images/flag/${trade['countryCode'] == 'KRW' ? 'KRW' : trade['countryCode'] == 'USD' ? 'USDKRW' : 'USD${trade['countryCode']}'}.png'),
                                    radius: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${trade['foreignCurrencyAmount']} ${trade['countryCode']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
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
                                      trade['status'] == 'WAIT' ? '예약중' : trade['status'] == 'COMPLETE' ? '거래완료' : '',
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${trade['koreanWonAmount']}원',
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
        });
  }
}