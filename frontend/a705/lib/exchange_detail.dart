import 'package:a705/bank_detail.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'models/BankDto.dart';

class ExchangeDetailPage extends StatefulWidget {
  final int selectedIndex;
  final String formattedRateText;
  const ExchangeDetailPage({
    required this.selectedIndex,
    required this.formattedRateText,
  });

  @override
  State<ExchangeDetailPage> createState() => _ExchangeDetailPageState();
}

class _ExchangeDetailPageState extends State<ExchangeDetailPage> {

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
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

  List<String> currency = [
    'USDKRW',
    'USDJPY',
    'USDCNY',
    'USDEUR',
    'USDGBP',
    'USDAUD',
    'USDCAD',
    'USDHKD',
    'USDPHP',
    'USDVND',
    'USDTWD',
    'USDSGD',
    'USDCZK',
    'USDNZD',
    'USDRUB',
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
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.yellow[100],
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
                        children: [
                          Expanded(
                            child: Container(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    width: 190,
                                    height: 55,
                                    // color: Colors.red,
                                    child:Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                          AssetImage('assets/images/flag/${currency[widget.selectedIndex]}.png'),
                                          radius: 10,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(  _valueList[widget.selectedIndex],
                                          style: const TextStyle(fontSize: 16),),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 110,
                                    height: 50,
                                    // color: Colors.red,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 15, 10, 10),
                                    child: Text(
                                      ' ${widget.formattedRateText}원',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
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
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              width: double.infinity,
                              height: 240,
                              decoration:BoxDecoration(
                                color: Colors.black.withOpacity(0.81),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black38),
                              ),
                              // 그래프 UI
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                 Container(
                                    margin : const EdgeInsets.fromLTRB(0, 0, 10,0),
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(getToday(),style: const TextStyle(color: Colors.white),),
                                          const Text(' 기준', style: TextStyle(color: Colors.white),),
                                        ],
                                      )),
                                  const LineChartSample2(),

                                ],
                              ),
                            ),
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
                 BankViewBuilder(
                    selectedIndex : widget.selectedIndex,
                   formattedRateText:  widget.formattedRateText,
                 ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BankViewBuilder extends StatefulWidget {
  final int selectedIndex;
  final String formattedRateText;
  const BankViewBuilder( {required this.selectedIndex, required this.formattedRateText});

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
    'IBK기업은행',
    'SC제일은행',
    '시티은행',
    'Sh수협은행',
    '부산은행',
    'DGB대구은행',

  ];


  List<String> currency1 = [
    'USDKRW',
    'USDJPY',
    'USDCNY',
    'USDEUR',
    'USDGBP',
    'USDAUD',
    'USDCAD',
    'USDHKD',
    'USDPHP',
    'USDVND',
    'USDTWD',
    'USDSGD',
    'USDCZK',
    'USDNZD',
    'USDRUB',

  ];


  Map<String, Map<String, String>> bankInfo = {
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

  double calculateCashBuyingPrice(double baseRate, String? buyingFee) {
    if (buyingFee == null || buyingFee == "서비스 미제공") {
      return baseRate; // 서비스 미제공일 경우 기본값 반환
    } else {
      double feePercentage = double.tryParse(buyingFee.replaceAll('%', '')) ?? 0.0;
      return baseRate + (baseRate * feePercentage / 100);
    }
  }

  double calculateCashPrice(double baseRate, String? sellginFee) {
    if (sellginFee == null || sellginFee == "서비스 미제공") {
      return baseRate; // 서비스 미제공일 경우 기본값 반환
    } else {
      double feePercentage = double.tryParse(sellginFee.replaceAll('%', '')) ?? 0.0;
      return baseRate - (baseRate * feePercentage / 100);
    }
  }


  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:  bankInfo.length,
      itemBuilder: (context, index) {
        final bankName = bankInfo.keys.elementAt(index); // 은행 이름
        final bankData = bankInfo[bankName]; // 은행 정보 맵
        final bankCode = bankData?['bankCode'];
        FeeInfo? feeInfo = bankInfoMap[bankName]?.fees[currency1[widget.selectedIndex]];
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BankDetailPage(
                        selectedIndex : widget.selectedIndex,
                        bankCode: bankCode!,
                    )),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  width: double.infinity,
                  height: 165,
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
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // CircleAvatar(
                              //   backgroundImage: AssetImage(
                              //       'assets/images/${currency1[index]}.png'),
                              //   radius: 10,
                              // ),
                              const SizedBox(width: 5),
                              Container(
                                margin: const EdgeInsets.fromLTRB(2,0,0,0),
                                child: Image.asset(
                                    'assets/images/banklogo/$bankCode.png'),
                                width: 150, // 이미지 너비 조절
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                '현찰 살 때',
                                style: TextStyle(fontSize: 16,
                                    height: 1.532),
                              ),
                              Text(
                                '현찰 팔 때',
                                style: TextStyle(fontSize: 16,
                                    height: 1.532),
                              ),
                              Text(
                                '송금 보낼 때',
                                style: TextStyle(fontSize: 16,
                                    height: 1.532),
                              )
                            ],
                          ),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '상세 환율',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${calculateCashBuyingPrice(
                                            double.tryParse(widget.formattedRateText.replaceAll(',', '').replaceAll('원', '')) ?? 0.0,
                                            feeInfo?.buying.toString() ?? "서비스 미제공" // feeInfo?.buying를 문자열로 변환
                                        ).toStringAsFixed(2)}원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                      Text(
                                        '${calculateCashPrice(
                                            double.tryParse(widget.formattedRateText.replaceAll(',', '').replaceAll('원', '')) ?? 0.0,
                                            feeInfo?.selling.toString() ?? "서비스 미제공" // feeInfo?.buying를 문자열로 변환
                                        ).toStringAsFixed(2)}원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                      Text(
                                        '${calculateCashBuyingPrice(
                                            double.tryParse(widget.formattedRateText.replaceAll(',', '').replaceAll('원', '')) ?? 0.0,
                                            feeInfo?.sending.toString() ?? "서비스 미제공" // feeInfo?.buying를 문자열로 변환
                                        ).toStringAsFixed(2)}원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '수수료',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${feeInfo?.buying ?? "서비스 미제공"}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                      Text(
                                        '${feeInfo?.selling ?? "서비스 미제공"}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                      Text(
                                        '${feeInfo?.sending ?? "서비스 미제공"}% ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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


// 그래프 위젯
class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    // const Color(0xff23b6e6),
    const Color(0xFFFFD954),
    const Color(0xFFFFD954),
    // const Color(0xff02d39a),
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
              left: 12,
              top: 20,
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
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 10:
        text = const Text('9월 3일', style: style);
        break;
      case 20:
        text = const Text('9월 14일', style: style);
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
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1310:
        text = '1,310';
        break;
      case 1330:
        text = '1,330';
        break;
      case 1350:
        text = '1,350';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      // backgroundColor: Colors.black,
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 10,
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
            showTitles: false,
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
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 30,
      minY: 1310,
      maxY: 1350,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1324.61), // 2023년 8월 25일
            FlSpot(1, 1324.61), // 2023년 8월 26일
            FlSpot(2, 1324.61), // 2023년 8월 27일
            FlSpot(3, 1320.88), // 2023년 8월 28일
            FlSpot(4, 1320.90), // 2023년 8월 29일
            FlSpot(5, 1324.03), // 2023년 8월 30일
            FlSpot(6, 1325.64), // 2023년 8월 31일
            FlSpot(7, 1318.45), // 2023년 9월 1일
            FlSpot(8, 1318.45), // 2023년 9월 2일
            FlSpot(9, 1318.46), // 2023년 9월 3일
            FlSpot(10, 1318.95), // 2023년 9월 4일
            FlSpot(11, 1332.08), // 2023년 9월 5일
            FlSpot(12, 1334.47), // 2023년 9월 6일
            FlSpot(13, 1337.91), // 2023년 9월 7일
            FlSpot(14, 1336.31), // 2023년 9월 8일
            FlSpot(15, 1336.31), // 2023년 9월 9일
            FlSpot(16, 1336.32), // 2023년 9월 10일
            FlSpot(17, 1322.84), // 2023년 9월 11일
            FlSpot(18, 1326.45), // 2023년 9월 12일
            FlSpot(19, 1330.77), // 2023년 9월 13일
            FlSpot(20, 1328.06), // 2023년 9월 14일
            FlSpot(21, 1329.41), // 2023년 9월 15일
            FlSpot(22, 1329.41), // 2023년 9월 16일
            FlSpot(23, 1329.42), // 2023년 9월 17일
            FlSpot(24, 1331.12), // 2023년 9월 18일
            FlSpot(25, 1328.90), // 2023년 9월 19일
            FlSpot(26, 1333.34), // 2023년 9월 20일
            FlSpot(27, 1341.74), // 2023년 9월 21일
            FlSpot(28, 1335.66), // 2023년 9월 22일
            FlSpot(29, 1335.66), // 2023년 9월 23일
            FlSpot(30, 1335.66), // 2023년 9월 24일
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
            show: false,
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



List<String> country = [
  '미국(달러)',
  '일본(엔)',
  '유럽(유로)',
  '영국(파운드)',
  '호주(달러)',
  '중국(위안)',
  '베트남(동)',
  '한국(원)',
  '홍콩(달러)',
  '캐나다(달러)',
  '체코(코루나)',
  '뉴질랜드(달러)',
  '필리핀(페소)',
  '러시아(루블)',
  '싱가폴(달러)',
  '대만(달러)',
];
List<String> currency = [
  'USD',
  'JPY',
  'EUR',
  'GBP',
  'AUD',
  'CNY',
  'VND',
  'KRW',
  'HKD',
  'CAD',
  'CZK',
  'NZD',
  'PHP',
  'RUB',
  'SGD',
  'TWD',
];
List<String> sign = ['\$', '¥', '€', '£', '\$', '¥', '₫','₩', '\$', '\$', 'Kč', '\$', '₱', '₽', '\$', '\$'];

List<int> unit = [1, 100, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1, 1, 1, 1];

class CountryListViewBuilder extends StatefulWidget {
  const CountryListViewBuilder({super.key});

  @override
  State<CountryListViewBuilder> createState() => _CountryListViewBuilderState();
}

class _CountryListViewBuilderState extends State<CountryListViewBuilder> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: country.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              idx = index;
            });
            Navigator.pop(context, idx);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            height: 50,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Color(0xFFFFD954),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/images/flag/${currency[index]}.png'),
                      radius: 10,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        country[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currency[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
