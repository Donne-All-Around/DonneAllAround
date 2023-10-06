import 'package:flutter/material.dart';
import 'package:a705/transaction_detail_page.dart';
import 'package:intl/intl.dart';
import 'review_create_page.dart';
import 'dart:convert'; // JSON 파싱을 위해 추가
import 'package:http/http.dart' as http;


class BuyRecordPage extends StatefulWidget {
  const BuyRecordPage({super.key});

  @override
  State<BuyRecordPage> createState() => BuyRecordPageState();
}

class BuyRecordPageState extends State<BuyRecordPage> {

  // 서버에서 받아온 데이터를 저장할 리스트
  List<Map<String, dynamic>> tradeList = [];

  @override
  void initState() {
    super.initState();
    // initState에서 서버로 GET 요청을 보냅니다.
    fetchBuyHistory();
  }

  void fetchBuyHistory() async {
    try {
      final url = Uri.parse('https://j9a705.p.ssafy.io/api/trade/history/buy');

      final headers = {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg',
        'Content-Type': 'application/json', // 필요에 따라 다른 헤더를 추가할 수 있습니다.
      };

      http.Response response = await http.get(url, headers: headers);
      String responseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        // 서버 응답이 성공인 경우
        final responseData = json.decode(responseBody);
        final data = responseData['data'];
        final tradeListData = data['tradeList'];

        setState(() {
          tradeList = List<Map<String, dynamic>>.from(tradeListData);
        });
        print('구매내역 잘 들어온다');
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
                '구매 내역',
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
                  Expanded(child: ListViewBuilder(buyRecordPageState: this)),
               ]
              )
            )
          ])
        )
    );
  }
}


class ListViewBuilder extends StatefulWidget {
  final BuyRecordPageState buyRecordPageState;

  const ListViewBuilder({Key? key, required this.buyRecordPageState}) : super(key: key);

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
        itemCount: widget.buyRecordPageState.tradeList.length,
        itemBuilder: (BuildContext context, int index) {
          final trade = widget.buyRecordPageState.tradeList[index];

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
                                ]
                              ),
                              Row(
                                children: [
                                  Text(
                                    trade['type'] == 'DIRECT'
                                      ? '${trade['administrativeArea']} ${trade['subLocality']} ${trade['thoroughfare']}'
                                      : '택배거래',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                    AssetImage('assets/images/flag/${trade['countryCode'] == 'KRW' ? 'KRW' : trade['countryCode'] == 'USD' ? 'USDKRW' : 'USD${trade['countryCode']}'}.png'),
                                    radius: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${NumberFormat("#,##0").format(trade['foreignCurrencyAmount'])} ${trade['countryCode']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '${NumberFormat("#,##0").format(trade['koreanWonAmount'])} 원',
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
                    child: trade['hasReview'] != false
                        ? null // false 일 때는 아무것도 반환하지 않음
                        : ElevatedButton(
                      onPressed: () {
                        final tradeID = trade['id'];
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
        });
  }
}