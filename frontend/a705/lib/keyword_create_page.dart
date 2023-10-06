import 'package:a705/storage.dart';
import 'package:flutter/material.dart';
import 'keyword_page.dart';
import 'package:a705/choose_location_page2.dart';
import 'package:a705/models/address.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class KeywordCreatePage extends StatefulWidget {
  const KeywordCreatePage({super.key});

  @override
  State<KeywordCreatePage> createState() => KeywordCreatePageState();
}

class KeywordCreatePageState extends State<KeywordCreatePage> {

  final _valueList = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '중국(위안) CNY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '캐나다(달러) CAD',
    '홍콩(달러) HKD',
    '필리핀(페소) PHP',
    '베트남(동) VND',
    '대만(달러) TWD',
    '싱가폴(달러) SGD',
    '체코(코루나) CZK',
    '뉴질랜드(달러) NZD',
    '러시아(루블) RUB',
  ];
  var _selectedValue = '미국(달러) USD';
  int idx = 0;

  List<String> currency = [
    'USD',
    'JPY',
    'CNY',
    'EUR',
    'GBP',
    'AUD',
    'CAD',
    'HKD',
    'PHP',
    'VND',
    'TWD',
    'SGD',
    'CZK',
    'NZD',
    'RUB',
  ];

  String _addr = "장소 선택";
  Address _address = Address(
      country: "",
      administrativeArea: "",
      subAdministrativeArea: "",
      locality: "",
      subLocality: "",
      thoroughfare: "",
      latitude: 0,
      longitude: 0);

  Future<void> _addNotification() async {
    // 화폐종류와 지역정보 가져오기
    final currency = _selectedValue;

    // 데이터 비어있는지 확인
    if (currency.isEmpty || _addr == "장소 선택") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content : Container(
              alignment: Alignment.center,
              height: 50,
              child: const Text(
                '화폐종류와 지역을 모두 입력하세요',
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

      final countryCode = _selectedValue.split(' ')[1].toUpperCase();

      // 정보가 모두 입력되었을 떄 서버로 전송
       // memberId 설정 (원하는 값으로 변경)
      final url = 'https://j9a705.p.ssafy.io/api/keyword';
      final accessToken =  await getJwtAccessToken();

      final requestData = {
        'countryCode': countryCode, // 여기에 나라 코드 설정
        'country': _address.country,
        'administrativeArea': _address.administrativeArea,
        'subAdministrativeArea': _address.subAdministrativeArea,
        'locality': _address.locality,
        'subLocality': _address.subLocality,
        'thoroughfare': _address.thoroughfare,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept-Charset': 'UTF-8',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          // 서버 응답이 성공적으로 왔을 때의 처리
          print('알림 추가가 성공적으로 저장되었습니다.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const KeywordPage()),
                (route) => false,
          );
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
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '직거래',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Text(
                  ' 키워드',
                  style: TextStyle(
                    color: Color(0xFFFFD954),
                    fontWeight: FontWeight.bold,
                  )
                ),
                Text(
                  ' 알림설정',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )
                )
              ]
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '화폐 종류',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedValue,
                            items: _valueList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/flag/${currency[_valueList.indexOf(value)] == 'KRW' ? 'KRW' : currency[_valueList.indexOf(value)] == 'USD' ? 'USDKRW' : 'USD${currency[_valueList.indexOf(value)]}'}.png'),
                                      radius: 10,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(value),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                idx = _valueList.indexOf(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '지역',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Address address = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChooseLocationPage2(
                                  37.5013068, 127.0396597)));
                      setState(() {
                        _addr =
                        "${address.subLocality} ${address.thoroughfare}";
                        _address = address;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: _addr == "장소 선택" ? 50 : null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _addr,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 60,
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
                          _addNotification();
                        },
                        child: const Text(
                          '알림 추가',
                          style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)
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
}
