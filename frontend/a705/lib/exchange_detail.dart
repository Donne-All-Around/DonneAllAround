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
    '호주': {'imagePath': 'assets/images/australia.png', 'currencyName': '호주 달러 AUD'},
    '일본': {'imagePath': 'assets/images/japan.png', 'currencyName': '일본 엔 JPY'},
  };

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
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20) ),
                                border: Border.all(color: Colors.black38),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(10, 10, 30, 10),
                                    width: 170,
                                    height: 55,
                                    color: Colors.red,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: _selectedValue,
                                        items: _valueList.map((value){
                                              return DropdownMenuItem(
                                                value: value,
                                                  child:Row(
                                                    children: [
                                                      Image.asset(
                                                        currencyInfo[value]!['imagePath']!,
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Text(currencyInfo[value]!['currencyName']!),
                                                    ],
                                                  ) ,);
                                            },
                                        ).toList(),
                                        onChanged: (value){
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
                          ],
                        ),

                      ],
                    ),
                  ),
                        // 은행별 환율 정보
                        const SizedBox(height: 20,),
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
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 20,),
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
