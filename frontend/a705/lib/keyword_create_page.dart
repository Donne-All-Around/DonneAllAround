import 'package:flutter/material.dart';
import 'keyword_page.dart';


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

  final _locationController = TextEditingController();

  @override
  void dispose() {
    // 페이지가 dispose될 때 컨트롤러를 정리
    _locationController.dispose();
    super.dispose();
  }

  void _addNotification() {
    // 화폐종류와 지역정보 가져오기
    final currency = _selectedValue;
    final location = _locationController.text;

    // 데이터 비어있는지 확인
    if (currency.isEmpty || location.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content : Container(
              alignment: Alignment.center,
              height: 50,
              child: const Text(
                '화폐종류와 지역정보를 모두 입력하세요',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              )
            ]
          );
        }
      );
    } else {
      // 정보가 모두 입력되었을 떄 서버로 전송
      // 서버로 데이터 전송코드 추가 해야함
      // Api 연결 후 데이터 10개 넘었을때 실패하는 코드 추가 필요
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KeywordPage()));
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
                                          'assets/images/flag/${currency[_valueList.indexOf(value)]}.png'),
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
                  TextField(
                    controller: _locationController,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: '지역을 입력하세요',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 3, color: Color(0xFFF6F6F6))
                      ),
                    ),
                    keyboardType: TextInputType.text,
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
