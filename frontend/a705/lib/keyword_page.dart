import 'package:flutter/material.dart';
import 'keyword_create_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Keyword {
  final String keywordId;
  final String countryCurrency;
  final String location;
  final String flagImageUrl;
  final String administrativeArea;
  final String subLocality;
  final String thoroughfare;
  final String countryCode;

  Keyword({
    required this.keywordId,
    required this.countryCurrency,
    required this.location,
    required this.flagImageUrl,
    required this.administrativeArea,
    required this.subLocality,
    required this.thoroughfare,
    required this.countryCode,
  });
}

class KeywordPage extends StatefulWidget {
  const KeywordPage({super.key});

  @override
  State<KeywordPage> createState() => KeywordPageState();
}

class KeywordPageState extends State<KeywordPage> {

  // 가상의 키워드 데이터 목록
  List<Keyword> keywords = [];

  Future<void> fetchKeywords() async {
    const memberId = "1";
    const url = 'https://j9a705.p.ssafy.io/api/keyword?memberId=$memberId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept-Charset": "utf-8", // 문자 인코딩을 UTF-8로 설정
        },
      );

      if (response.statusCode == 200) {
        final responseData = utf8.decode(response.bodyBytes);
        final keywordList = json.decode(responseData)['data'];

        final newKeywords = keywordList.map<Keyword>((keywordData) {
          final countryCode = keywordData['countryCode'];
          final countryCurrency = getCurrencyName(countryCode);
          return Keyword(
            countryCurrency: countryCurrency,
            location: '${keywordData['administrativeArea']} ${keywordData['subLocality']} ${keywordData['thoroughfare']}',
            flagImageUrl: 'assets/images/flag/${keywordData['countryCode'] == 'KRW' ? 'KRW' : keywordData['countryCode'] == 'USD' ? 'USDKRW' : 'USD${keywordData['countryCode']}'}.png',
            administrativeArea: keywordData['administrativeArea'],
            subLocality: keywordData['subLocality'],
            thoroughfare: keywordData['thoroughfare'],
            countryCode: keywordData['countryCode'],
            keywordId: '',
          );
        }).toList();

        setState(() {
          keywords = newKeywords; // 데이터를 업데이트하고 화면을 다시 그립니다.
        });
        print('호출됨?');
      } else {
        // API 호출 실패 처리
        print('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 오류 처리
      print('오류: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // 페이지가 처음 로드될 때 API를 호출하여 데이터를 가져옵니다.
    fetchKeywords();
  }

  String getCurrencyName(String countryCode) {
    final currencyInfo = {
      'USD' : '미국(달러) USD',
      'JPY' : '일본(엔) JPY',
      'CNY' : '중국(위안) CNY',
      'EUR' : '유럽(유로) EUR',
      'GBP' : '영국(파운드) GBP',
      'AUD' : '호주(달러) AUD',
      'CAD' : '캐나다(달러) CAD',
      'HKD' : '홍콩(달러) HKD',
      'PHP' : '필리핀(페소) PHP',
      'VND' : '베트남(동) VND',
      'TWD' : '대만(달러) TWD',
      'SGD' : '싱가폴(달러) SGD',
      'CZK' : '체코(코루나) CZK',
      'NZD' : '뉴질랜드(달러) NZD',
      'RUB' : '러시아(루블) RUB',
    };

    return currencyInfo[countryCode] ?? ''; // 해당하는 은행 코드를 찾아 반환하거나 기본값으로 빈 문자열 반환
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
            '나의 키워드',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: keywords.length,
          itemBuilder: (context, index) {
            final keyword = keywords[index];
            return Dismissible(
                key: Key(keyword.countryCurrency), // 고유한 키 설정
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    bool? confirmExit = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // 원하는 Radius 값으로 설정
                          ),
                          title: Text("확인"),
                          content: Text("채팅방을 나가시겠어요?"),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                ),
                                minimumSize:
                                MaterialStateProperty.all<Size>(
                                    Size(100, 50)),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.grey.shade200),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.black),
                              ),
                              child: Text(
                                "취소",
                                style: TextStyle(fontSize: 17),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                ),
                                minimumSize:
                                MaterialStateProperty.all<Size>(
                                    Size(100, 50)),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.red),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                              ),
                              child: Text(
                                "나가기",
                                style: TextStyle(fontSize: 17),
                              ),
                              onPressed: () async {
                                // 서버에 삭제 요청을 보내는 코드
                                const memberId = "1"; // memberId 설정
                                final keywordId = keyword.keywordId; // 키워드의 고유 ID 가져오기
                                final deleteUrl = 'https://j9a705.p.ssafy.io/api/keyword/$keywordId?memberId=$memberId';

                                try {
                                  final response = await http.delete(
                                    Uri.parse(deleteUrl),
                                    headers: {
                                      "Accept-Charset": "utf-8", // 문자 인코딩을 UTF-8로 설정
                                    },
                                  );

                                  if (response.statusCode == 200) {
                                    // 성공적으로 삭제되었을 때의 처리
                                    // 삭제된 항목을 keywords 리스트에서 제거
                                    setState(() {
                                      keywords.remove(keyword);
                                    });
                                    Navigator.of(context).pop(true); // 대화 상자 닫기
                                  } else {
                                    // 삭제 실패 시의 처리
                                    print('키워드 삭제 실패: ${response.statusCode}');
                                  }
                                } catch (e) {
                                  // 오류 처리
                                  print('오류: $e');
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return confirmExit == true;
                  }
                  return false;
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
            child: Container(
              width: 400,
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                    child: Image.asset(
                      keyword.flagImageUrl,
                      width: 40,
                      height: 40,
                    )
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                keyword.countryCurrency,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right
                            ),
                            const SizedBox(height:5),
                            Text(
                                keyword.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right
                            )
                          ]
                        )
                      )
                    )
                  )
                ]
              )
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
              if (keywords.length < 10) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KeywordCreatePage()));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('키워드는 10개까지만 등록이 가능합니다'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('확인')
                        )
                      ]
                    );
                  }
                );
              }
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