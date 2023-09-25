import 'package:a705/chatting_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BankDetailPage extends StatefulWidget {
  const BankDetailPage({super.key});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {

  final _bankList = ['신한은행', '하나은행'];
  var _selectedValue = '신한은행';

  Map<String, Map<String, String>> bankInfo = {
    '신한은행': {'imagePath': 'assets/images/USD.png', 'currencyName': '신한은행'},
    '하나은행': {
      'imagePath': 'assets/images/AUD.png',
      'currencyName': '하나은행'
    },
  };

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
  }
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

 // 수수료율
  final _percentList = ['현찰 살 때', '현찰 팔 때', '송금 보낼 때'];
  var _selectedValue3 = '현찰 살 때';


  // 텍스트 필드 컨트롤러
  final TextEditingController _moneyController1 = TextEditingController(text: "1 ");
  final TextEditingController _moneyController2 = TextEditingController(text: "1,300.00 ");
  final TextEditingController _percentController = TextEditingController(text: "30");



  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            elevation: 0,
            title: const Text(
              '환율 검색',
              style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: double.infinity,
                      height: 470,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(0.1),
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    border: Border.all(color: Colors.transparent),
                                    color: const Color(0xFFFFD954),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                        const EdgeInsets.fromLTRB(10, 10, 30, 10),
                                        width: 170,
                                        height: 55,
                                        // color: Colors.red,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: _selectedValue,
                                            items: _bankList.map(
                                                  (value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        bankInfo[value]![
                                                        'imagePath']!,
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(bankInfo[value]![
                                                      'currencyName']!,
                                                        style: const TextStyle(fontWeight: FontWeight.bold),),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedValue = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0,30, 10),
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                width: 220,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black38),
                                ),
                                child: Text(
                                  getToday(),
                                  style: const TextStyle(fontSize: 25),),
                              ),

                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    _moneyController2.clear();
                                    _moneyController1.clear();
                                    _percentController.clear();
                                  });
                                },
                                icon: const Icon(Icons.cached_rounded),
                                iconSize: 35,
                                color: Colors.grey,),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                    '1,000.00 ₩',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: double.infinity,
                                  height: 60,
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  // 드롭다운
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 182,
                                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                          color:  Colors.grey[200],
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
                                        width: 140,
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        // color: Colors.red,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                        ),
                                        child: TextField(
                                          controller: _moneyController1,
                                          decoration:  InputDecoration(
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
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: double.infinity,
                                  height: 60,
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  // 드롭다운
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 182,
                                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                          border: Border.all(color: Colors.transparent),
                                          color:  Colors.grey[200],
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
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          // color: Colors.red,
                                          // decoration: BoxDecoration(
                                          //   borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          //   border: Border.all(color: Colors.transparent),
                                          // ),
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                width: 180,
                                height: 50,
                                // color: Colors.red,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black38),
                                  color: Colors.grey[200]
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: _selectedValue3,
                                    items: _percentList.map(
                                        (value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child:
                                               Container(
                                                 margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                 child: Text(value,
                                                    style: const TextStyle(fontWeight: FontWeight.bold,),
                                                 textAlign: TextAlign.center,),
                                               ),
                                              );
                                        }
                                    ).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedValue3 = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                width: 110,
                                height: 50,
                                // color: Colors.red,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black38),
                                ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // border: Border.all(color: Colors.black38),
                                  color:  const Color(0xFFFFD954),
                                ),
                                child:IconButton(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  onPressed: (){
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
                    // 나라별 환율
                    const SizedBox(height: 20,),
                    const ListViewBuilder(),
                  ],
                ),
          ),
        ),
      ),
    );
  }

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
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black38),
                ),
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
                            child: const Text(
                              '1,300.00 원',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 20, color: Colors.red),))
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
          ],
        );
      },
    );
  }
}


