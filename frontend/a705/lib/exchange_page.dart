import 'package:a705/bank_detail.dart';
import 'package:a705/exchange_detail.dart';
import 'package:a705/providers/exchange_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

import 'models/BankDto.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final _valueList1 = [
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

  Map<String, double>? exchangeRates; // 환율 데이터를 저장할 변수

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    try {
      final exchangeProvider = ExchangeRateProvider();
      final response = await exchangeProvider.fetchCurrencyData();
      // API 응답 데이터 파싱
      final exchangeResponse = response;
      if (exchangeResponse.success) {
        setState(() {
          // 성공적으로 데이터를 받아왔을 때만 exchangeRates 업데이트
          exchangeRates = {
            'USDKRW': exchangeResponse.quotes.usdKrw,
            'USDJPY': exchangeResponse.quotes.usdJpy,
            'USDCNY': exchangeResponse.quotes.usdCny,
            'USDEUR': exchangeResponse.quotes.usdEur,
            'USDGBP': exchangeResponse.quotes.usdGbp,
            'USDAUD': exchangeResponse.quotes.usdAud,
            'USDCAD': exchangeResponse.quotes.usdCad,
            'USDHKD': exchangeResponse.quotes.usdHkd,
            'USDPHP': exchangeResponse.quotes.usdPhp,
            'USDVND': exchangeResponse.quotes.usdVnd,
            'USDTWD': exchangeResponse.quotes.usdTwd,
            'USDSGD': exchangeResponse.quotes.usdSgd,
            'USDCZK': exchangeResponse.quotes.usdCzk,
            'USDNZD': exchangeResponse.quotes.usdNzd,
            'USDRUB': exchangeResponse.quotes.usdRub,
          };
          _moneyController2.text =
              exchangeResponse.quotes.usdKrw.toStringAsFixed(2);
        });
      } else {
        // API 요청은 성공했지만, 응답이 실패한 경우에 대한 처리
        print('API 요청 성공, 응답 실패: ${exchangeResponse.terms}');
      }
    } catch (e) {
      // API 요청 중 오류 발생
      print('Error fetching exchange rates: $e');
    }
  }

  double? calculateRate(String baseCurrency, String targetCurrency) {
    if (exchangeRates != null &&
        exchangeRates!.containsKey(baseCurrency) &&
        exchangeRates!.containsKey(targetCurrency)) {
      final baseRate = exchangeRates![baseCurrency];
      final targetRate = exchangeRates![targetCurrency];

      if (baseCurrency == 'USDKRW' && targetCurrency == 'USDJPY') {
        return baseRate! / targetRate!;
      } else {
        return baseRate! / targetRate!;
      }
    }
    return null;
  }

  double? calculateUsd(String targetCurrency) {
    if (exchangeRates != null && exchangeRates!.containsKey(targetCurrency)) {
      return exchangeRates![targetCurrency];
    }
    return null;
  }

  // 이중환전
  double calculateDoubleExchange() {


    return 1.2;
  }

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
  List<String> sign = [
    '\$',
    '¥',
    '¥',
    '€',
    '£',
    '\$',
    '\$',
    '\$',
    '₱',
    '₫',
    '\$',
    '\$',
    'Kč',
    '\$' '₽'
  ];

  List<int> unit = [1, 100, 1, 1, 1, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1];

  List<String> country2 = [
    '미국(달러)',
    '한국(원)',
    '일본(엔)',
    '중국(위안)',
    '유럽(유로) ',
    '영국(파운드)',
    '호주(달러)',
    '캐나다(달러)',
    '홍콩(달러)',
    '필리핀(페소)',
    '베트남(동)',
    '대만(달러)',
    '싱가폴(달러)',
    '체코(코루나)',
    '뉴질랜드(달러)',
    '러시아(루블)',
  ];
  List<String> currency2 = [
    'USD',
    'KRW',
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
  List<String> sign2 = [
    '\$',
    '₩',
    '¥',
    '¥',
    '€',
    '£',
    '\$',
    '\$',
    '\$',
    '₱',
    '₫',
    '\$',
    '\$',
    'Kč',
    '\$' '₽'
  ];

  List<int> unit2 = [1, 1, 100, 1, 1, 1, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1];

  int idx1 = 0;
  int idx2 = 1;
  int idx3 = 8;
  int idx4 = 1;

  String calculateExchangeRate(int baseIdx, int targetIdx) {
    double? rate;
    String base;
    String target;
    // 기준 통화와 대상 통화를 가져옵니다.
    // String baseCurrency = currency1[baseIdx-1];
    // String targetCurrency = currency1[targetIdx-1];

    // 기준 통화와 대상 통화가 같은 경우, 환율은 1.0입니다.
    // if (baseCurrency == targetCurrency) {
    //   rate = 1.0;
    // } else {
    //   // 환율을 계산합니다.
    //   rate = calculateRate(targetCurrency, baseCurrency);
    // }

    if (currency[baseIdx] != 'USD') {
      base = currency1[targetIdx - 1];
      target = currency1[baseIdx];
      rate = calculateRate(base, target);
    } else if (currency[baseIdx] == 'USD') {
      rate = calculateUsd(currency1[targetIdx - 1]);
    } else if (currency[targetIdx] != 'USD') {
      rate = calculateUsd(currency1[targetIdx - 1]);
    }
    // 미국이 타겟 일 때, 계산 값 추가.

    if (rate != null) {
      double amountToConvert =
      double.parse(_moneyController1.text.replaceAll(',', ''));
      double convertedAmount = amountToConvert * rate;
      String formattedAmount = convertedAmount.toStringAsFixed(2);
      setState(() {
        // UI 업데이트를 수행
        // _moneyController2.text = '${_moneyController1.text.isNotEmpty
        //     ? (double.parse(_moneyController1.text.replaceAll(',', '')) * rate!).toStringAsFixed(2)
        //     : '0.00'} ${sign[idx2]}';
        // _moneyController2.text = formattedAmount;
      });
      return formattedAmount;
    }
    return "";
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
  }

  String selectedButton = '직접'; // 선택된 버튼

  final _bankList = [
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
    'DGB대구은행',];

  var _selectedValue5 = '신한은행';
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

  // 텍스트 필드 컨트롤러
  final TextEditingController _moneyController1 =
  TextEditingController(text: "1");
  final TextEditingController _moneyController2 =
  TextEditingController(text: "");
  final TextEditingController _moneyController3 =
  TextEditingController(text: " ");
  final TextEditingController _moneyController4 =
  TextEditingController(text: "");
  final TextEditingController _percentController =
  TextEditingController(text: "0");
  bool _isDouble = false;
  bool _isdoublecalculate = false;
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
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "환율",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                const SizedBox(
                  height: 10,
                ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (_isDouble == false)
                            IconButton(
                              onPressed: () {
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
                              color: Colors.grey,
                            ),
                          if (_isDouble)
                            IconButton(
                              onPressed: () {
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
                              color: Colors.grey,
                            ),
                        ],
                      ),
                      if (_isDouble)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                    onPressed: () {
                                      setState(() {
                                        selectedButton = '직접';
                                        _isDouble = false;
                                        _iscalculate = false;
                                        _isdoublecalculate = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: selectedButton == '직접'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    child: const Text(
                                      '직접',
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                      onPressed: () {
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
                                        backgroundColor: selectedButton == '이중'
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      child: const Text('이중')),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        int idx = await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      5 *
                                                      4,
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        30, 20, 30, 20),
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                        5 *
                                                        4,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '통화 선택',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Expanded(
                                                            child:
                                                            CountryListViewBuilder()),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                        setState(() {
                                          idx1 = idx;
                                          _moneyController1.text =
                                              (1 * unit[idx1]).toString();
                                          _moneyController2.text =
                                              calculateExchangeRate(idx1, idx2);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 5),
                                        color: const Color(0xFFF7F7F7),
                                        width:
                                        MediaQuery.of(context).size.width /
                                            2 -
                                            28,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/flag/${currency[idx1] == 'KRW' ? 'KRW' : currency[idx1] == 'USD' ? 'USDKRW' : 'USD${currency[idx1]}'}.png'),
                                              radius: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  country[idx1],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  currency[idx1],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2 -
                                          72,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: _moneyController1,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  Colors.transparent)),
                                          suffixText: ' ${sign[idx1]}',
                                        ),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _moneyController2.text =
                                                calculateExchangeRate(
                                                    idx1, idx2);
                                          });
                                        },
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
                                margin:
                                const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        int idx = await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      5 *
                                                      4,
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        30, 20, 30, 20),
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                        5 *
                                                        4,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '통화 선택',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Expanded(
                                                            child:
                                                            CountryListViewBuilder2()),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                        setState(() {
                                          idx2 = idx;
                                          // _moneyController2.text = (1 * unit[idx2]).toString();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 5),
                                        color: const Color(0xFFF7F7F7),
                                        width:
                                        MediaQuery.of(context).size.width /
                                            2 -
                                            28,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/flag/${currency2[idx2] == 'KRW' ? 'KRW' : currency2[idx2] == 'USD' ? 'USDKRW' : 'USD${currency2[idx2]}'}.png'),
                                              radius: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  country2[idx2],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  currency2[idx2],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2 -
                                          72,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: _moneyController2,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  Colors.transparent)),
                                          suffixText: sign2[idx2],
                                          // suffixText: rate != null ? ' 1 USD = ${rate.toStringAsFixed(2)} ${sign[idx2]}' : '',
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        int idx = await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      5 *
                                                      4,
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        30, 20, 30, 20),
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                        5 *
                                                        4,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '통화 선택',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Expanded(
                                                            child:
                                                            CountryListViewBuilder()),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                        setState(() {
                                          idx3 = idx;
                                          _moneyController3.text =
                                              (1 * unit[idx3]).toString();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 5),
                                        color: const Color(0xFFF7F7F7),
                                        width:
                                        MediaQuery.of(context).size.width /
                                            2 -
                                            28,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/flag/${currency[idx3] == 'KRW' ? 'KRW' : currency[idx3] == 'USD' ? 'USDKRW' : 'USD${currency[idx3]}'}.png'),
                                              radius: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  country[idx3],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  currency[idx3],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2 -
                                          72,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: _moneyController3,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  Colors.transparent)),
                                          suffixText: ' ${sign[idx3]}',
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
                                margin:
                                const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        int idx = await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      5 *
                                                      4,
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        30, 20, 30, 20),
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                        5 *
                                                        4,
                                                    child: const Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text(
                                                          '통화 선택',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Expanded(
                                                            child:
                                                            CountryListViewBuilder2()),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                        setState(() {
                                          idx4 = idx;
                                          _moneyController4.text =
                                              (1 * unit[idx4]).toString();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 5),
                                        color: const Color(0xFFF7F7F7),
                                        width:
                                        MediaQuery.of(context).size.width /
                                            2 -
                                            28,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/flag/${currency2[idx4] == 'KRW' ? 'KRW' : currency2[idx4] == 'USD' ? 'USDKRW' : 'USD${currency2[idx4]}'}.png'),
                                              radius: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  country2[idx4],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  currency2[idx4],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2 -
                                          72,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: _moneyController4,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          enabledBorder:
                                          const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  Colors.transparent)),
                                          suffixText: ' ${sign2[idx4]}',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              width: 160,
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
                                  items: _bankList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: Text(
                                          bankInfo[value]!['currencyName']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedValue5 = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                      if (_isDouble == false)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                              width: 70,
                              height: 50,
                              // color: const Color(0xFFFFD954),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // border: Border.all(color: Colors.black38),
                                color: const Color(0xFFFFD954),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                onPressed: () {
                                  setState(() {
                                    _iscalculate = true;
                                    calculateExchangeRate(idx1, idx2);
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                              width: 70,
                              height: 50,
                              // color: const Color(0xFFFFD954),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // border: Border.all(color: Colors.black38),
                                color: const Color(0xFFFFD954),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                onPressed: () {
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
                              ChatBubbleClipper6(type: BubbleType.sendBubble),
                              context),
                        ),
                      ),
                    ],
                  ),
                if (_iscalculate)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          width: double.infinity,
                          height: 60,
                          child: getbankView(
                              ChatBubbleClipper6(type: BubbleType.sendBubble),
                              context),
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
                // const ListViewBuilder(),
                  Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _valueList1.length,
                          itemBuilder: (context, index) {
                            String formattedRate = 'N/A'; // 초기값 설정

                            if (exchangeRates != null) {
                              if (currency1[index] == 'USDKRW') {
                                // 미국 달러(USD)은 그대로 표시
                                final exchangeRate =
                                exchangeRates![currency1[index]];
                                if (exchangeRate != null) {
                                  formattedRate =
                                      exchangeRate.toStringAsFixed(2);
                                }
                              } else if (currency1[index] == 'USDJPY' || currency1[index] == 'USDVND') {
                                final rate =
                                    calculateRate('USDKRW', currency1[index])! *
                                        100;
                                if (rate != null) {
                                  formattedRate = rate.toStringAsFixed(2);
                                }
                              } else {
                                // 다른 국가의 환율 계산
                                final rate =
                                calculateRate('USDKRW', currency1[index]);
                                if (rate != null) {
                                  formattedRate = rate.toStringAsFixed(2);
                                }
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                final selectedRate = formattedRate;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExchangeDetailPage(
                                        selectedIndex: index,
                                        formattedRateText: selectedRate,
                                      )),
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 20),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      width: double.infinity,
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
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/flag/${currency1[index]}.png'),
                                                    radius: 10,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    _valueList1[index],
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$formattedRate 원',
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              )
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
                        ),
                      ),
                    ],
                  ),
                if (_iscalculate)
                  BankViewBuilder(
                    key: UniqueKey(),
                    idx1: idx1,
                    // exchangeRates: exchangeRates,
                    moneyController2:
                    double.tryParse(_moneyController2.text) ?? 0.0,
                  )
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
    backGroundColor: const Color(0xFFFFD954),
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
    backGroundColor: const Color(0xFFFFD954),
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
    backGroundColor: const Color(0xFFFFD954),
    child: Container(
      // constraints: const BoxConstraints(
      //   // maxWidth: MediaQuery.of(context).size.width * 1,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: const Text(
                  " 직접 환전 대비",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
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
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: const Text(
                  "절약 ",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

class BankViewBuilder extends StatefulWidget {
  final int idx1;

  // Map<String, double>? exchangeRates;
  // TextEditingController moneyController2 = TextEditingController();
  final double moneyController2;

  BankViewBuilder({
    Key? key,
    required this.idx1,
    // required this.exchangeRates,
    required this.moneyController2,
  }) : super(key: key);

  @override
  State<BankViewBuilder> createState() =>
      _BankViewBuilderState(idx1: idx1, moneyController2: moneyController2);
}

class _BankViewBuilderState extends State<BankViewBuilder> {
  final int idx1; // idx1 값을 저장할 변수 추가
  final double moneyController2;

  _BankViewBuilderState({
    required this.idx1,
    required this.moneyController2, // moneyController2 추가
  });

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

  int _selectedIdx = 0;

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
    // 송금 보낼 때, 현찰 살 때,
    if (buyingFee == null || buyingFee == "서비스 미제공") {
      return baseRate; // 서비스 미제공일 경우 기본값 반환
    } else {
      double feePercentage =
          double.tryParse(buyingFee.replaceAll('%', '')) ?? 0.0;
      return baseRate + (baseRate * feePercentage / 100);
    }
  }

  double calculateCashPrice(double baseRate, String? sellginFee) {
    // 현찰 팔 때,
    if (sellginFee == null || sellginFee == "서비스 미제공") {
      return baseRate; // 서비스 미제공일 경우 기본값 반환
    } else {
      double feePercentage =
          double.tryParse(sellginFee.replaceAll('%', '')) ?? 0.0;
      return baseRate - (baseRate * feePercentage / 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (idx1 == 0) {
      _selectedIdx = 0;
    } else if (idx1 >= 2) {
      _selectedIdx = idx1;
    } else if (idx1 == 1) {
      _selectedIdx = 1;
    }
    return ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: bankInfo.length,
      itemBuilder: (context, index) {
        final bankName = bankInfo.keys.elementAt(index); // 은행 이름
        final bankData = bankInfo[bankName]; // 은행 정보 맵
        final bankCode = bankData?['bankCode'];
        final currencyName = bankData?['currencyName'];
        FeeInfo? feeInfo = bankInfoMap[bankName]?.fees[currency1[_selectedIdx]];
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BankDetailPage(
                          selectedIndex: idx1,
                          bankCode: bankCode!,
                          currencyName: currencyName!,
                        )),
                  );
                  setState(() {
                    _selectedIdx = idx1;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Image.asset(
                                    'assets/images/banklogo/$bankCode.png'),
                                width: 150, // 이미지 너비 조절
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                                style: TextStyle(fontSize: 16, height: 1.532),
                              ),
                              Text(
                                '현찰 팔 때',
                                style: TextStyle(fontSize: 16, height: 1.532),
                              ),
                              Text(
                                '송금 보낼 때',
                                style: TextStyle(fontSize: 16, height: 1.532),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 50,
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
                                        '${calculateCashBuyingPrice(widget.moneyController2 as double, feeInfo?.buying.toString() ?? "서비스 미제공").toStringAsFixed(2)}원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                      Text(
                                        '${calculateCashPrice(widget.moneyController2 as double, feeInfo?.selling.toString() ?? "서비스 미제공").toStringAsFixed(2)}원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            height: 1.532),
                                      ),
                                      Text(
                                        '${calculateCashBuyingPrice(widget.moneyController2 as double, feeInfo?.sending.toString() ?? "서비스 미제공").toStringAsFixed(2)}원',
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
                                        '${feeInfo?.sending ?? "서비스 미제공"}%',
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

List<String> country = [
  '미국(달러)',
  '일본(엔)',
  '중국(위안)',
  '유럽(유로) ',
  '영국(파운드)',
  '호주(달러)',
  '캐나다(달러)',
  '홍콩(달러)',
  '필리핀(페소)',
  '베트남(동)',
  '대만(달러)',
  '싱가폴(달러)',
  '체코(코루나)',
  '뉴질랜드(달러)',
  '러시아(루블)',
];
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
List<String> sign = [
  '\$',
  '¥',
  '¥',
  '€',
  '£',
  '\$',
  '\$',
  '\$',
  '₱',
  '₫',
  '\$',
  '\$',
  'Kč',
  '\$' '₽'
];

List<int> unit = [1, 100, 1, 1, 1, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1];

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
                      backgroundImage: AssetImage(
                          'assets/images/flag/${currency[index] == 'KRW' ? 'KRW' : currency[index] == 'USD' ? 'USDKRW' : 'USD${currency[index]}'}.png'),
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

List<String> country2 = [
  '미국(달러)',
  '한국(원)',
  '일본(엔)',
  '중국(위안)',
  '유럽(유로) ',
  '영국(파운드)',
  '호주(달러)',
  '캐나다(달러)',
  '홍콩(달러)',
  '필리핀(페소)',
  '베트남(동)',
  '대만(달러)',
  '싱가폴(달러)',
  '체코(코루나)',
  '뉴질랜드(달러)',
  '러시아(루블)',
];
List<String> currency2 = [
  'USD',
  'KRW',
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
List<String> sign2 = [
  '\$',
  '₩',
  '¥',
  '¥',
  '€',
  '£',
  '\$',
  '\$',
  '\$',
  '₱',
  '₫',
  '\$',
  '\$',
  'Kč',
  '\$' '₽'
];

List<int> unit2 = [1, 1, 100, 1, 1, 1, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1];

class CountryListViewBuilder2 extends StatefulWidget {
  const CountryListViewBuilder2({super.key});

  @override
  State<CountryListViewBuilder2> createState() =>
      _CountryListViewBuilder2State();
}

class _CountryListViewBuilder2State extends State<CountryListViewBuilder2> {
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
                      backgroundImage: AssetImage(
                          'assets/images/flag/${currency2[index] == 'KRW' ? 'KRW' : currency2[index] == 'USD' ? 'USDKRW' : 'USD${currency2[index]}'}.png'),
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
                        country2[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currency2[index],
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