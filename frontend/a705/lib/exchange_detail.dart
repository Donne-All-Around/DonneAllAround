import 'package:a705/bank_datail.dart';
import 'package:flutter/material.dart';

class ExchangeDetailPage extends StatefulWidget {
  const ExchangeDetailPage({super.key});

  @override
  State<ExchangeDetailPage> createState() => _ExchangeDetailPageState();
}

class _ExchangeDetailPageState extends State<ExchangeDetailPage> {
  final _valueList = ['미국', '호주', '일본'];
  var _selectedValue = '미국';

  Map<String, Map<String, String>> currencyInfo = {
    '미국': {'imagePath': 'assets/images/usa.png', 'currencyName': '미국 달러 USD'},
    '호주': {
      'imagePath': 'assets/images/australia.png',
      'currencyName': '호주 달러 AUD'
    },
    '일본': {'imagePath': 'assets/images/japan.png', 'currencyName': '일본 엔 JPY'},
  };

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
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  width: 350,
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
                            width: 348,
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
                                      items: _valueList.map(
                                        (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  currencyInfo[value]![
                                                      'imagePath']!,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(currencyInfo[value]![
                                                    'currencyName']!),
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
                                Container(
                                  width: 120,
                                  height: 50,
                                  // color: Colors.red,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 10, 10),
                                  child: const Text(
                                    ' 1,300.00원',
                                    style: TextStyle(
                                        fontSize: 22,
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
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        width: 350,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black38),
                        ),
                        child:  Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.fromLTRB(30, 10, 20, 0),
                                    child:  const Text('하나은행', style: TextStyle(fontSize: 16),)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 10, 40, 10),
                                  child: const Text('상세 환율          수수료', style: TextStyle(color: Colors.grey),),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  // color: Colors.red,
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                                  // color: Colors.red,
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('1,354.29원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('1,354.29원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('1,354.29원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  // color: Colors.red,
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('1.75%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('1.75%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('1.75%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 은행 상세 페이지로.
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BankDetailPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        width: 350,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black38),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        width: 350,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black38),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        width: 350,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black38),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
