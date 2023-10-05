import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'exchange_record_page.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ExchangeRecordCreatePage extends StatefulWidget {
  const ExchangeRecordCreatePage({super.key});

  @override
  State<ExchangeRecordCreatePage> createState() => ExchangeRecordCreatePageState();
}

class ExchangeRecordCreatePageState extends State<ExchangeRecordCreatePage> {

  // POST 요청을 보낼 함수
  Future<void> sendExchangeRecord(String tradingBaseRate, countryCode, bankCode) async {
    try {
      // POST 요청으로 보낼 데이터

      final Map<String, dynamic> data = {
        'exchangeDate': selectedDate.toIso8601String(), // 환전 일시
        'countryCode': currency[idx], // 화폐 종류 코드
        'foreignCurrencyAmount': int.parse(_currencyController.text), // 화폐 종류에 해당하는 금액
        'koreanWonAmount': int.parse(_priceController.text), // 가격
        'bankCode': bankCode, // 은행 코드
        'preferentialRate': int.parse(_discountController.text),
        'tradingBaseRate': tradingBaseRate,
      };
      const accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtODkyMy04OTIzIiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4NDg2OX0.ezbsG-Tn7r5xmqjSbPu5YU6r0-igo3lmRIFbLsyMyEg';

      // POST 요청 보내기
      final response = await http.post(
        Uri.parse('https://j9a705.p.ssafy.io/api/exchange/record/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // 서버 응답이 성공적으로 왔을 때의 처리
        print('환전 기록이 성공적으로 저장되었습니다.');
      } else {
        // 서버 응답이 실패했을 때의 처리
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      // 오류 발생 시 처리
      print('오류: $e');
    }
  }

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
  List<String> sign = ['\$',  '¥', '¥','€', '£', '\$', '\$', '\$', '₱', '₫', '\$', '\$','Kč', '\$' '₽' ];

  final _bankList1 = [
    '하나은행',
    '우리은행',
    'KB국민은행',
    '신한은행',
    'NH농협은행',
    'IBK기업은행',
    'SC제일은행',
    '시티은행',
    'Sh수협은행',
    '부산은행',
    'DGB대구은행',
  ];
  var _selectedBank = '신한은행';

  final Map<String, Map<String, String>> bankInfo = {
    '하나은행': {'currencyName': '하나은행', 'bankCode': '081'},
    '우리은행': {'currencyName': '우리은행', 'bankCode': '020'},
    'KB국민은행': {'currencyName': 'KB국민은행', 'bankCode': '004'},
    '신한은행': {'currencyName': '신한은행', 'bankCode': '088'},
    'NH농협은행': {'currencyName': 'NH농협은행', 'bankCode': '011'},
    'IBK기업은행': {'currencyName': 'IBK기업은행', 'bankCode': '003'},
    'SC제일은행': {'currencyName': 'SC제일은행', 'bankCode': '023'},
    '시티은행': {'currencyName': '시티은행', 'bankCode': '027'},
    'Sh수협은행': {'currencyName': 'Sh수협은행', 'bankCode': '007'},
    '부산은행': {'currencyName': '부산은행', 'bankCode': '032'},
    'DGB대구은행': {'currencyName': 'DGB대구은행', 'bankCode': '031'},
  };

  DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _currencyController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  // 작성 완료 버튼을 눌렀을 때 호출되는 함수
  void _onSubmit() {
    // 입력값 확인
    if (_selectedValue.isEmpty || _priceController.text.isEmpty || _discountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('화폐 종류, 가격, 우대율을 모두 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    // KoreanWonAmount를 double로 변환
    final koreanWonAmount = double.parse(_priceController.text);

    // tradingBaseRate 계산
    final tradingBaseRate = koreanWonAmount / double.parse(_currencyController.text);

    // tradingBaseRate를 소수점 둘째 자리까지 반올림하여 문자열로 변환
    final tradingBaseRateString = NumberFormat('0.00').format(tradingBaseRate);

    final countryCode = _selectedValue.split(' ')[1].toUpperCase();

    // 선택된 은행에 대한 bankCode 찾기
    final bankCode = bankInfo[_selectedBank]?['bankCode'] ?? '';

    // 입력값이 모두 채워져 있다면 작성 완료 처리를 진행
    sendExchangeRecord(tradingBaseRateString, countryCode, bankCode);
    final data = {
      'exchangeDate': '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
      'countryCode': countryCode,
      'foreignCurrencyAmount': _currencyController.text,
      'koreanWonAmount': _priceController.text,
      'bankCode': bankCode,
      'preferentialRate': _discountController.text,
      'tradingBaseRate': tradingBaseRateString,
    };
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ExchangeRecordPage()),
          (route) => false,
    );
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
              '나의 환전',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )
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
                    '환전 일시',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    height: 50,
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
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        )
                      )
                    )
                  ),
                  const SizedBox(height: 15),
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
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _currencyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                        ),
                        suffixText: ' ${sign[idx]}',
                      ),
                      cursorColor: Colors.black87,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '가격',
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
                    child: const Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/images/flag/KRW.png'),
                          radius: 10,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '대한민국(원화) KRW',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        borderSide:
                        BorderSide(color: Color(0xFFF2F2F2), width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        borderSide:
                        BorderSide(color: Color(0xFFF2F2F2), width: 3),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixText: ' ₩',
                    ),
                    cursorColor: Colors.black87,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '은행',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButtonHideUnderline(
                          child:  DropdownButton(
                            value: _selectedBank,
                            items: _bankList1.map(
                              (value) {
                                return  DropdownMenuItem(
                                  value: value,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: _selectedBank == value ? FontWeight.bold : FontWeight.normal,
                                      )
                                    ),
                                  ),
                                );
                              }
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBank = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                      ]
                    )
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '우대율',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  TextField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixText: ' %',
                    ),
                    cursorColor: Colors.black87,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
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
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD954), // 배경 색상을 지정합니다.
                      ),
                      child: const Text(
                        '작성 완료',
                        style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)
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