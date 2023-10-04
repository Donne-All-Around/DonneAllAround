import 'package:flutter/material.dart';
import 'exchange_record_create_page.dart';
import 'package:intl/intl.dart';
// import 'dart:convert'; // JSON 파싱을 위해 추가
// import 'package:http/http.dart' as http;


class ExchangeRecordPage extends StatefulWidget {
  const ExchangeRecordPage({super.key});

  @override
  State<ExchangeRecordPage> createState() => ExchangeRecordPageState();
}

// 수정, 삭제 모달
class CustomModalWidget extends StatelessWidget {
  const CustomModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Container(
        width: 330,
        height: 170,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                )
              ]
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                // 수정하기 동작 구현
              },
              child: Container(
                width: 270,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFF1D77E8)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "수정하기",
                    style: TextStyle(
                      color: Color(0xFF1D77E8),
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              )
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                // 삭제하기 동작 구현
              },
              child: Container(
                width: 270,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFFF53C3C)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "삭제하기",
                    style: TextStyle(
                      color: Color(0xFFF53C3C),
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              )
            )
          ]
        )
      )
    );
  }
}


class ExchangeRecordPageState extends State<ExchangeRecordPage> {


  // 임의의 데이터로 초기화한 exchangeDataList
  List<Map<String, dynamic>> exchangeDataList = [
    {
      "id": 1,
      "countryCode": "USD",
      "bankCode": "081",
      "koreanWonAmount": 992147,
      "foreignCurrencyAmount": 740,
      "tradingBaseRate": 1331.66,
      "preferentialRate": 30,
      "exchangeDate": "2022-09-20",
    },
    {
      "id": 2,
      "countryCode": "USD",
      "bankCode": "081",
      "koreanWonAmount": 992147,
      "foreignCurrencyAmount": 740,
      "tradingBaseRate": 1331.66,
      "preferentialRate": 30,
      "exchangeDate": "2022-09-21",
    },
    {
      "id": 3,
      "countryCode": "USD",
      "bankCode": "081",
      "koreanWonAmount": 992147,
      "foreignCurrencyAmount": 740,
      "tradingBaseRate": 1331.66,
      "preferentialRate": 30,
      "exchangeDate": "2022-08-21",
    },
    // 다른 임의의 데이터도 추가 가능
  ];
  // // 서버에서 받아온 데이터를 저장할 리스트 일단 주석처리 나중에 백 연결되면 주석해제
  // List<Map<String, dynamic>> exchangeDataList = [];
  //
  // // 서버로부터 데이터를 가져오는 메서드
  // Future<void> fetchExchangeData() async {
  //   final apiUrl = 'http://SERVER_URL/api/exchange/records'; // 서버 URL로 변경
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //     if (response.statusCode == 200) {
  //       // 서버 응답이 성공인 경우 JSON 데이터 파싱
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       // JSON 데이터를 리스트에 저장
  //       setState(() {
  //         exchangeDataList = jsonData.cast<Map<String, dynamic>>();
  //       });
  //     } else {
  //       // 서버 응답이 실패인 경우 예외 처리
  //       print('서버 오류: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // 오류 발생 시 예외 처리
  //     print('오류: $e');
  //   }
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // 페이지가 로드될 때 서버로부터 데이터를 가져오도록 초기화 메서드 호출
  //   fetchExchangeData();
  // }

  String? previousDate2;

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
            '나의 환전',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: exchangeDataList.length,
          itemBuilder: (BuildContext context, int index) {
            final exchangeData = exchangeDataList[index];
            // 'yyyy-MM-dd' 형식의 문자열을 파싱하여 DateTime 객체로 변환
            final exchangeDate = DateFormat('yyyy-MM-dd', 'ko_KR').parse(exchangeData['exchangeDate']);
            // DateTime 객체를 'yyyy년 MM월 dd일 E요일' 형식의 문자열로 포맷
            final formattedDate1 = DateFormat('yyyy년 MM월 dd일 E요일', 'ko_KR').format(exchangeDate);
            final formattedDate2 = DateFormat('yyyy년 MM월', 'ko_KR').format(exchangeDate);
            // 이전 항목의 formattedDate2와 현재 항목의 formattedDate2를 비교하여 표시 여부 결정
            final showFormattedDate2 = previousDate2 != formattedDate2;
            previousDate2 = formattedDate2; // 현재 항목의 formattedDate2를 이전 항목으로 설정

              return Container(
                margin: EdgeInsets.fromLTRB(16, showFormattedDate2 ? 20 : 0, 16, 0),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showFormattedDate2)
                    Text(
                      formattedDate2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      )
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 350,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomModalWidget();
                                      }
                                    );
                                  }
                                )
                              ]
                            )
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exchangeData['tradingBaseRate'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      )
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '신한은행',
                                          style: TextStyle(
                                            fontSize: 17,
                                          )
                                        ),
                                        Text(
                                          '우대율${exchangeData['preferentialRate']}%',
                                          style: TextStyle(
                                          fontSize: 13,
                                          )
                                        )
                                      ]
                                    )
                                  ]
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            exchangeData['foreignCurrencyAmount'].toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0984E3),
                                            )
                                          ),
                                          Text(
                                            ' USD',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0984E3)
                                            )
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0984E3),
                                              shape: BoxShape.circle,
                                            )
                                          )
                                        ]
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          exchangeData['koreanWonAmount'].toString() + ' KRW',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF5656),
                                          )
                                        ),
                                        SizedBox(width: 10),
                                        CircleAvatar(
                                          backgroundImage:
                                          AssetImage('assets/images/flag/KRW.png'),
                                          radius: 16,
                                        ),
                                      ]
                                    )
                                  ]
                                )
                              ]
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              );
          }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD954),
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExchangeRecordCreatePage()));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  '추가하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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