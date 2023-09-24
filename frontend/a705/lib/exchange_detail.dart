import 'package:a705/bank_detail.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black38),
                    color: Colors.yellow[100],
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
                      const SizedBox(height: 10,),
                      // 그래프 공간
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 320,
                            height: 240,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38),
                            ),
                            // 그래프 UI
                            child: const LineChartSample2(),
                          ),
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

// 그래프 위젯
class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
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
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
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

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}