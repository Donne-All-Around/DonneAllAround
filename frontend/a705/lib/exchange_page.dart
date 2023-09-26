import 'package:a705/bank_detail.dart';
import 'package:a705/exchange_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
  }
  
  String selectedButton = '직접'; // 선택된 버튼

 // 첫번째 통화
  final _valueList1 = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '한국(원) KRW',
    '홍콩(달러) HKD'
  ];
  var _selectedValue1 = '미국(달러) USD';
  int idx1 = 0;

  List<String> currency1 = [
    'USD',
    'JPY',
    'EUR',
    'GBP',
    'AUD',
    'CNY',
    'VND',
    'KRW',
    'HKD'
  ];
  List<String> sign1 = ['\$', '¥', '€', '£', '\$', '¥', '₫','₩', '\$'];
  
 // 두번째 통화
  final _valueList2 = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '한국(원) KRW',
    '홍콩(달러) HKD'
  ];
  var _selectedValue2 = '한국(원) KRW';
  int idx2 = 7;

  List<String> currency2 = [
    'USD',
    'JPY',
    'EUR',
    'GBP',
    'AUD',
    'CNY',
    'VND',
    'KRW',
    'HKD'
  ];
  List<String> sign2 = ['\$', '¥', '€', '£', '\$', '¥', '₫', '₩','\$'];

  // 세번째 통화
  final _valueList3 = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '한국(원) KRW',
    '홍콩(달러) HKD'
  ];
  var _selectedValue3 = '베트남(동) VND';
  int idx3 = 6;

  List<String> currency3 = [
    'USD',
    'JPY',
    'EUR',
    'GBP',
    'AUD',
    'CNY',
    'VND',
    'KRW',
    'HKD'
  ];
  List<String> sign3 = ['\$', '¥', '€', '£', '\$', '¥', '₫','₩', '\$'];

  // 네번째 통화
  final _valueList4 = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '한국(원) KRW',
    '홍콩(달러) HKD'
  ];
  var _selectedValue4 = '한국(원) KRW';
  int idx4 = 7;

  List<String> currency4 = [
    'USD',
    'JPY',
    'EUR',
    'GBP',
    'AUD',
    'CNY',
    'VND',
    'KRW',
    'HKD'
  ];
  List<String> sign4 = ['\$', '¥', '€', '£', '\$', '¥', '₫', '₩','\$'];


  final _bankList = ['신한은행', '하나은행'];
  var _selectedValue5 = '신한은행';
  Map<String, Map<String, String>> bankInfo = {
    '신한은행': { 'currencyName': '신한은행'},
    '하나은행': {'currencyName': '하나은행'},
  };


  // 텍스트 필드 컨트롤러
  final TextEditingController _moneyController1 = TextEditingController(text: "1 ");
  final TextEditingController _moneyController2 = TextEditingController(text: "1,300.00 ");
  final TextEditingController _moneyController3 = TextEditingController(text: "2 ");
  final TextEditingController _moneyController4 = TextEditingController(text: "600.00 ");
  final TextEditingController _percentController = TextEditingController(text: "30");
   bool _isDouble = false;
   bool _isdoublecalculate  = false;
   bool _iscalculate = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
                children: [
                  // 상단 바 (환율 검색)
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color(0xFFFFD954),
                    ),
                    child:  Center(
                      child: RichText(
                        text: const TextSpan(
                          children:  [
                            TextSpan(
                              text: "환율",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            TextSpan(
                              text: " 검색",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        // textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // body 페이지
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    width: double.infinity,
                    height: _isDouble ? 470 : 310,
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
                    child:Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20,10, 10),
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                              width: 230,
                              height: 40,
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
                              child: Text(
                                getToday(),
                                style: const TextStyle(fontSize: 25),),
                            ),
                            const SizedBox(width: 10,),
                            if (_isDouble == false)
                            IconButton(
                                onPressed: (){
                                 setState(() {
                                   _iscalculate = false;
                                   _isDouble = false;
                                   _isdoublecalculate = false;
                                   _moneyController1.clear();
                                   _moneyController2.clear();
                                 });
                                },
                                icon: const Icon(Icons.cached_rounded),
                                iconSize: 40,
                                color: Colors.grey,),
                            if (_isDouble)
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    _isDouble = true;
                                    _isdoublecalculate = false;
                                    _moneyController3.clear();
                                    _moneyController4.clear();
                                    _percentController.clear();
                                  });
                                },
                                icon: const Icon(Icons.cached_rounded),
                                iconSize: 40,
                                color: Colors.grey,),
                          ],
                        ),
                        if (_isDouble)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                  width: double.infinity,
                                  height: 60,
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[200],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 3,
                                          offset: const Offset(0, 0),
                                        ),
                                      ]),
                                  child: const Text(
                                    '+ 2,300 ₩',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                                width: 150,
                                height: 20,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            selectedButton = '직접';
                                            _isDouble = false;
                                            _iscalculate = false;
                                            _isdoublecalculate = false;
                                          });
                                        },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                          backgroundColor: selectedButton == '직접' ? Colors.green : Colors.grey,
                                      ),

                                        child: const Text('직접',),),
                                    const SizedBox(width: 5),
                                    ElevatedButton(
                                        onPressed:(){
                                          setState(() {
                                            selectedButton = '이중';
                                            _isDouble = true;
                                            _iscalculate = false;
                                            // Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(builder: (context) => const DoubleCurrencyPage()),
                                            //     );
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: selectedButton == '이중' ? Colors.red : Colors.grey,
                                        ),
                                        child: const Text('이중') ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isDouble == false)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: double.infinity,
                                  height: 60,
                                  // color: Colors.red,
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
                                  // 드롭다운
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width / 2 - 4,
                                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                          color: const Color(0xFFF7F7F7),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedValue1,
                                            items: _valueList1.map(
                                                  (value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/${currency1[_valueList1.indexOf(value)]}.png'),
                                                        radius: 10,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(value),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedValue1 = value!;
                                                idx1 = _valueList1.indexOf(value);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:  MediaQuery.of(context).size.width / 2 - 72,
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        // color: Colors.red,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                        ),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          controller: _moneyController1,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            enabledBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent)
                                            ),
                                            suffixText: ' ${sign1[idx1]}',
                                          ),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_isDouble == false)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                width: double.infinity,
                                height: 60,
                                // color: Colors.red,
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
                                child:  Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width / 2 - 5,
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                        // border: Border.all(color: Colors.transparent),
                                        color: Color(0xFFF7F7F7),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _selectedValue2,
                                          items: _valueList2.map(
                                                (value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/${currency2[_valueList2.indexOf(value)]}.png'),
                                                      radius: 10,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(value),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue2 = value!;
                                              idx2 = _valueList2.indexOf(value);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 72,
                                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      // color: Colors.red,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                        border: Border.all(color: Colors.transparent),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: _moneyController2,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          enabledBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent)
                                          ),
                                          suffixText: ' ${sign2[idx2]}',
                                        ),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),if (_isDouble)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: double.infinity,
                                  height: 60,
                                  // color: Colors.red,
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
                                  // 드롭다운
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width / 2 - 5,
                                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                          color:  const Color(0xFFF7F7F7),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedValue3,
                                            items: _valueList3.map(
                                                  (value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/${currency3[_valueList3.indexOf(value)]}.png'),
                                                        radius: 10,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(value),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedValue3 = value!;
                                                idx3 = _valueList3.indexOf(value);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:  MediaQuery.of(context).size.width / 2 - 72,
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        // color: Colors.red,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                        ),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          controller: _moneyController3,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            enabledBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.transparent)
                                            ),
                                            suffixText: ' ${sign3[idx3]}',
                                          ),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_isDouble)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  width: double.infinity,
                                  height: 60,
                                  // color: Colors.red,
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
                                  child:  Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width / 2 - 5,
                                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                          color:  const Color(0xFFF7F7F7),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedValue4,
                                            items: _valueList4.map(
                                                  (value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/${currency4[_valueList4.indexOf(value)]}.png'),
                                                        radius: 10,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(value),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedValue4 = value!;
                                                idx4 = _valueList4.indexOf(value);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:  MediaQuery.of(context).size.width / 2 - 72,
                                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        // color: Colors.red,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                        ),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          controller: _moneyController4,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            enabledBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.transparent)
                                            ),
                                            suffixText: ' ${sign4[idx4]}',
                                          ),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_isDouble)
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                              width: 180,
                              height: 50,
                              // color: Colors.red,
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: _selectedValue5,
                                  items: _bankList.map(
                                          (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child:
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                            child: Text(bankInfo[value]![
                                            'currencyName']!,
                                              style: const TextStyle(fontWeight: FontWeight.bold,),
                                              textAlign: TextAlign.center,),
                                          ),
                                        );
                                      }
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedValue5 = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                              width: 110,
                              height: 50,
                              // color: Colors.red,
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
                              child:  TextField(
                                controller: _percentController,
                                cursorColor: Colors.black38,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration:  InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  suffixText: '%',
                                ),
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        if (_isDouble == false)
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(270, 10, 10, 0),
                            width: 70,
                            height: 50,
                            // color: const Color(0xFFFFD954),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(color: Colors.black38),
                              color:  const Color(0xFFFFD954),
                            ),
                            child:IconButton(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                              onPressed: (){
                                setState(() {
                                  _iscalculate = true;
                                });
                              },
                              icon: const Icon(Icons.drag_handle_rounded),
                              iconSize: 50,
                              color: Colors.white,

                            ),
                          ),
                        ],
                      ),
                        if (_isDouble)
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(270, 10, 10, 0),
                                width: 70,
                                height: 50,
                                // color: const Color(0xFFFFD954),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // border: Border.all(color: Colors.black38),
                                  color:  const Color(0xFFFFD954),
                                ),
                                child:IconButton(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  onPressed: (){
                                    setState(() {
                                      _isdoublecalculate = true;
                                    });
                                  },
                                  icon: const Icon(Icons.drag_handle_rounded),
                                  iconSize: 50,
                                  color: Colors.white,

                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // 말풍선
                  if (_isDouble == false && _iscalculate == false)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          width: double.infinity,
                          height: 60,
                          child: getSenderView(
                              ChatBubbleClipper6(type: BubbleType.sendBubble), context),
                        ),
                      ),
                    ],
                  ),
                 if(_iscalculate)
                   Row(
                     children: [
                       Expanded(
                         child: Container(
                           margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                           width: double.infinity,
                           height: 60,
                           child:  getbankView(
                               ChatBubbleClipper6(type: BubbleType.sendBubble), context),
                         ),
                       ),
                     ],
                   ),
                 if (_isdoublecalculate)
                   Row(
                     children: [
                       Expanded(
                         child: Container(
                           margin: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                           width: double.infinity,
                           height: 120,
                           child: getCalculateView(
                               ChatBubbleClipper4(type: BubbleType.sendBubble),
                               context),
                         ),
                       ),
                     ],
                   ),

                 //국가별 실시간 환율
                  if (_isDouble == false && _iscalculate == false)
                    const ListViewBuilder(),

                  if (_iscalculate)
                    const BankViewBuilder(),
                  ],
              ),
          ),
        ),
      ),
    );
  }

   // 기본말풍선
  getSenderView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    elevation: 0,
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.all(0),
    backGroundColor:const Color(0xFFFFD954),
    child: Container(
      // constraints: const BoxConstraints(
      //   // maxWidth: MediaQuery.of(context).size.width * 1,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Text(
            " 국가별 실시간 환율",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            "을 확인 할 수 있어요! ",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    ),
  );
  
  // 계산기 누르면 은행별 말풍선
  getbankView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    elevation: 0,
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.all(0),
    backGroundColor:const Color(0xFFFFD954),
    child: Container(
      // constraints: const BoxConstraints(
      //   // maxWidth: MediaQuery.of(context).size.width * 1,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Text(
            " 은행 별 예상 금액 ",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            "을 확인 할 수 있어요! ",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    ),
  );
  
  // 이중환전 말풍선
 getCalculateView(CustomClipper clipper, BuildContext context) => ChatBubble(
   clipper: clipper,
   elevation: 0,
   alignment: Alignment.topLeft,
   margin: const EdgeInsets.all(0),
   backGroundColor:const Color(0xFFFFD954),
   child: Container(
     // constraints: const BoxConstraints(
     //   // maxWidth: MediaQuery.of(context).size.width * 1,
     // ),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(30),
     ),
     child:  Column(
       children: [
         Row(
           children: [
             Container(
               margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
               child: const Text(
                 " 직접 환전 대비",
                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
               ),
             ),
           ],
         ),
         Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Container(
               margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
               child: const Text(
                 "2,300 원",
                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
               ),
             ),
             Container(
               margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
               child: const Text(
                 "절약 ",
                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25),
               ),
             )
           ],
         ),
       ],
     ),
   ),
 );
  
}

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  final _valueList1 = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '한국(원) KRW',
    '홍콩(달러) HKD'
  ];
  int idx1 = 0;

  List<String> currency1 = [
    'USD',
    'JPY',
    'EUR',
    'GBP',
    'AUD',
    'CNY',
    'VND',
    'KRW',
    'HKD'
  ];


  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _valueList1.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExchangeDetailPage()),
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  width: double.infinity,
                  height: 50,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                20, 10, 0, 0),
                            width: 200,
                            // color: Colors.red,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/images/${currency1[index]}.png'),
                                  radius: 10,
                                ),
                                const SizedBox(width: 10),
                                Text( _valueList1[index],
                                  style: const TextStyle(fontSize: 16),),
                              ],
                            ),),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: const Text(
                                '1,300.00 원',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),))
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 계산기 눌렀을 때, 은행별 리스트 => 은행 목록과 사진으로 바꿔야 함!!
class BankViewBuilder extends StatefulWidget {
  const BankViewBuilder({super.key});

  @override
  State<BankViewBuilder> createState() => _BankViewBuilderState();
}

class _BankViewBuilderState extends State<BankViewBuilder> {
  final _valueList1 = [
    '하나은행',
    '우리은행',
    'KB국민은행',
    '신한은행',
    'NH농협은행',
    '기업은행',
    'SC제일은행',
    '시티은행',
    '수협은행',
    '부산은행',
    '대구은행',
    '전북은행',
    '경남은행',
    '제주은행',
  ];

  int idx1 = 0;

  // List<String> currency1 = [
  //   'USD',
  //   'JPY',
  //   'EUR',
  //   'GBP',
  //   'AUD',
  //   'CNY',
  //   'VND',
  //   'KRW',
  //   'HKD'
  // ];


  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _valueList1.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BankDetailPage()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  width: double.infinity,
                  height: 160,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                20, 10, 0, 0),
                            width: 200,
                            // color: Colors.red,
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundImage:
                                //   AssetImage('assets/images/${currency1[index]}.png'),
                                //   radius: 10,
                                // ),
                                const SizedBox(width: 10),
                                Text( _valueList1[index],
                                  style: const TextStyle(fontSize: 16),),
                              ],
                            ),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                0, 10, 40, 10),
                            child: const Text(
                              '상세 환율              수수료',
                              style: TextStyle(color: Colors.grey),),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                20, 0, 20, 10),
                            // color: Colors.red,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Row(
                                  children: [
                                    Text('현찰 살 때'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('현찰 팔 때'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('송금 보낼 때'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                10, 0, 30, 10),
                            // color: Colors.red,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Row(
                                  children: [
                                    Text('1,354.29원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('1,354.29원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('1,354.29원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                10, 0, 0, 10),
                            // color: Colors.red,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Row(
                                  children: [
                                    Text('1.75%', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('1.75%', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('1.75%', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
