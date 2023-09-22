import 'package:a705/bank_detail.dart';
import 'package:flutter/material.dart';

class ExchangeDetailPage extends StatefulWidget {
  const ExchangeDetailPage({super.key});

  @override
  State<ExchangeDetailPage> createState() => _ExchangeDetailPageState();
}

class _ExchangeDetailPageState extends State<ExchangeDetailPage> {
  final _valueList = [
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
  var _selectedValue = '미국(달러) USD';

  List<String> currency = [
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

  String selectedButton = ''; // 선택된 버튼
  
  @override
  Widget build(BuildContext context) {
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
                // 나라별 상세 통화
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  width: 360,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 358,
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
                                  width: 180,
                                  height: 55,
                                  // color: Colors.red,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _selectedValue,
                                      items: _valueList.map(
                                        (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/${currency[_valueList.indexOf(value)]}.png'),
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
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 110,
                                  height: 50,
                                  // color: Colors.red,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 10, 10),
                                  child: const Text(
                                    ' 1,300.00원',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedButton = '1w';
                                });
                              },
                              child: Text(
                                '1w',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedButton == '1w' ? Colors.black : Colors.grey,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedButton = '1m';
                                });
                              },
                              child:  Text(
                                '1m',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedButton == '1m' ? Colors.black : Colors.grey,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedButton = '3m';
                                });
                              },
                              child: Text(
                                '3m',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedButton == '3m' ? Colors.black : Colors.grey,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedButton = '6m';
                                });
                              },
                              child: Text(
                                '6m',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedButton == '6m' ? Colors.black : Colors.grey,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedButton = '1y';
                                });
                              },
                              child: Text(
                                '1y',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedButton == '1y' ? Colors.black : Colors.grey,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),

                // 은행별 환율 정보
                const SizedBox(
                  height: 20,
                ),
                const BankViewBuilder(),

              ],
            ),
          ),
        ),
      ),
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
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BankDetailPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                width: 370,
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
          ],
        );
      },
    );
  }
}
