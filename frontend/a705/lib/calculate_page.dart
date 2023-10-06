import 'package:a705/providers/exchange_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'exchange_record_page.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  bool _iscalculate = false;

  // 날짜 선택
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime(2022, 09, 20);
  DateTime date3 = DateTime.now();

  final _bankList1 = [
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
  var _selectedBank = '신한은행';

  int idx1 = 0;
  final TextEditingController _percentController =
  TextEditingController();

  Map<String, dynamic> exchangeRecord = {
    "id": 0,
    "memberId": 0,
    "countryCode": "",
    "bankCode": "",
    "exchangeDate": "",
    "koreanWonAmount": 0,
    "foreignCurrencyAmount": 0,
    "preferentialRate": 0,
    "tradingBaseRate": 0
  };





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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "이익/손실",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text: "계산",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline_rounded),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        width: double.infinity,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                  // 날짜 선택
                                  child: GestureDetector(
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: date1,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                      if (selectedDate != null) {
                                        setState(() {
                                          date1 = selectedDate;
                                        });
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        "${date1.year.toString()}.${date1.month.toString().padLeft(2, '0')}.${date1.day.toString().padLeft(2, '0')}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                exchangeRecord['countryCode'] == ""
                                    ? const SizedBox(width: 10)
                                    : Row(
                                  children: [
                                    Text(
                                      '${exchangeRecord['foreignCurrencyAmount']} ${exchangeRecord['countryCode']}',
                                      style:
                                      const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 3),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 10, 10),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/flag/USD${exchangeRecord['countryCode'] == 'USD' ? 'KRW' : exchangeRecord['countryCode']}.png'),
                                        radius: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 3,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]),
                                    child: const Text(
                                      '원',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 35,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  width: 110,
                                  height: 30,
                                  // color: Colors.red,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Map<String, dynamic> _exchangeRecord =
                                      await showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  5 *
                                                  4,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      topRight: Radius
                                                          .circular(10),
                                                      topLeft: Radius
                                                          .circular(
                                                          10))),
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    10, 20, 10, 20),
                                                height:
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    5 *
                                                    4,
                                                child:
                                                const ExchangeRecordPage(type: "calculate",),
                                              ),
                                            );
                                          });
                                      setState(() {
                                        exchangeRecord = _exchangeRecord;
                                        _percentController.text = exchangeRecord['preferentialRate'].toString();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      '환전기록',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]),
                                    child: Container(
                                        height: 50,
                                        width: 120,
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        child: Center(
                                            child: Text(
                                              exchangeRecord['currencyName'] ?? "",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 20),
                                            )))),
                                const SizedBox(
                                  width: 10,
                                ),
                                // 우대율
                                Container(
                                  margin:
                                  const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  width: 100,
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
                                  child: TextField(
                                    controller: _percentController,
                                    cursorColor: Colors.black38,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      suffixText: '%',
                                    ),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                        fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  width: 70,
                                  height: 50,
                                  // color: const Color(0xFFFFD954),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(color: Colors.black38),
                                    color: const Color(0xFFFFD954),
                                  ),
                                  child: IconButton(
                                    padding:
                                    const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                    onPressed: () {
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_iscalculate == false)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          width: double.infinity,
                          height: 60,
                          child: getCalculateView(
                              ChatBubbleClipper6(type: BubbleType.sendBubble),
                              context),
                        ),
                      ),
                    ],
                  ),
                if (_iscalculate)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          width: double.infinity,
                          height: 350,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 초기값 기록 시기.
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(7),
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                              Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 0),
                                            ),
                                          ]),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final selectedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: date2,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now(),
                                          );
                                          if (selectedDate != null) {
                                            setState(() {
                                              date2 = selectedDate;
                                            });
                                          }
                                        },
                                        child: Text(
                                          "${date2?.year.toString()}.${date2?.month.toString().padLeft(2, '0')}.${date2?.day.toString().padLeft(2, '0')}",
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 기록 시 환전 값
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    width: 170,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]),
                                    child: const Text(
                                      '992,147.00 원',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 오늘 기준.
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(7),
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                              Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 0),
                                            ),
                                          ]),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final selectedDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: date3,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now(),
                                          );
                                          if (selectedDate != null) {
                                            setState(() {
                                              date3 = selectedDate;
                                            });
                                          }
                                        },
                                        child: Text(
                                          "${date3?.year.toString()}.${date3?.month.toString().padLeft(2, '0')}.${date3?.day.toString().padLeft(2, '0')}",
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 현재 환전 값.
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    width: 170,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]),
                                    child: const Text(
                                      '1,000,000.48 원',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      // 차액
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            width: 100,
                                            height: 50,
                                            child: const Text(
                                              '7,853원',
                                              style: TextStyle(
                                                fontSize: 27,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 상승 or 하락
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            width: 100,
                                            height: 40,
                                            child: const Text(
                                              '상승',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // 그래프
                                  const Expanded(child: LineChartSample2()),
                                ],
                              ),
                            ],
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

  getCalculateView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    elevation: 0,
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.all(0),
    backGroundColor: const Color(0xFFFFD954),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 5),
              Text(
                " 환전 시기에 따른 ",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                "손익/손실 ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "을 ",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                "비교 ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "해보세요! ",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
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
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 40,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]),
              const SizedBox(height: 5),
              InkWell(
                  onTap: () {
                    // 수정하기 동작 구현
                  },
                  child: Container(
                      width: 270,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xFF1D77E8)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("수정하기",
                            style: TextStyle(
                                color: Color(0xFF1D77E8),
                                fontWeight: FontWeight.bold)),
                      ))),
              const SizedBox(height: 15),
              InkWell(
                  onTap: () {
                    // 삭제하기 동작 구현
                  },
                  child: Container(
                      width: 270,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xFFF53C3C)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text("삭제하기",
                            style: TextStyle(
                                color: Color(0xFFF53C3C),
                                fontWeight: FontWeight.bold)),
                      )))
            ])));
  }
}

// 환전기록 리스트뷰 (모달)
class RecordViewBuilder extends StatefulWidget {
  const RecordViewBuilder({super.key});

  @override
  State<RecordViewBuilder> createState() => _RecordViewBuilderState();
}

class _RecordViewBuilderState extends State<RecordViewBuilder> {
  final _recordList = ['1331.66'];

  // Map<String, Map<String, String>> recordInfo = {
  //   '1331.66': {
  //     'currencyName': 'USD',
  //     'targetPrice': '740',
  //     'percent': '30',
  //     'exchange': '1331.66',
  //     'krw': '992.147',
  //     'date': '2022.09.20',
  //     'bank': '신한은행'
  //   }
  // };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {},
    );
  }
}

// 환전 차이 그래프
class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    // const Color(0xff23b6e6),
    // const Color(0xff02d39a),
    const Color(0xFFFFD954),
    const Color(0xFFFFD954),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 0,
              top: 10,
              bottom: 0,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('1331.66', style: style);
        break;
      case 4:
        text = const Text('1336.50', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '1331.66';
        break;
      case 4:
        text = '1336.50';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      backgroundColor: Colors.white,
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 29,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 43,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 5,
      minY: 1331,
      maxY: 1337,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(2, 1331.66), // 2023년 8월 25일
            FlSpot(4, 1336.50), // 2023년 8월 26일
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}