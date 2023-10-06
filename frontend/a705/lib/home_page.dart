import 'package:a705/providers/exchange_providers.dart';
import 'package:a705/providers/trade_providers.dart';
import 'package:a705/transaction_detail_page.dart';
import 'package:a705/transaction_page.dart';
import 'package:a705/notification_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'choose_location_page2.dart';
import 'models/TradeDto.dart';
import 'models/address.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _valueList = ['최신순', '낮은 가격순', '단위 당 낮은 가격순'];
  var _selectedValue = '최신순';
  int _idx = 0;

  TradeProviders tradeProvider = TradeProviders();
  List<TradeDto> trade = [];

  ScrollController _scrollController = ScrollController();

  int size = -1;

  Future initTrade() async {
    trade = await tradeProvider.getLatestTrade(
        currency[_idx], null, null, null, null, null, "강남구", "역삼동");
    size = trade.length;
    setState(() {});
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${date.year}.${date.month}.${date.day}';
    }
  }

  @override
  void initState() {
    initTrade();
    _fetchExchangeRates();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the bottom, load more data
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _addr = "강남구 역삼동";
  Address _address = Address(
    country: null,
    administrativeArea: null,
    subAdministrativeArea: null,
    locality: null,
    subLocality: null,
    thoroughfare: null,
    latitude: 37.5013068,
    longitude: 127.0396597,
  );

  late Map<String, double> exchangeRates;

  Future<void> _fetchExchangeRates() async {
    exchangeRates = {'USDKRW': 0};
    try {
      final exchangeProvider = ExchangeRateProvider();
      final response = await exchangeProvider.fetchCurrencyData();
      print(response);
      // API 응답 데이터 파싱
      final exchangeResponse = response;
      if (exchangeResponse.success) {
        setState(() {
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

  void loadMoreData() async {
    List<TradeDto> newItems;
    if (_selectedValue == "최신순") {
      int lastListIdx = trade[trade.length - 1].id;
      newItems = await tradeProvider.getLatestTrade(
          currency[_idx],
          lastListIdx,
          _address.country,
          _address.administrativeArea,
          _address.subAdministrativeArea,
          _address.locality,
          _address.subLocality,
          _address.thoroughfare);
    } else if (_selectedValue == "낮은 가격순") {
      int lastListIdx = trade[trade.length - 1].id;
      newItems = await tradeProvider.getLowestTrade(
          currency[_idx],
          lastListIdx,
          _address.country,
          _address.administrativeArea,
          _address.subAdministrativeArea,
          _address.locality,
          _address.subLocality,
          _address.thoroughfare);
    } else {
      int lastListIdx = trade[trade.length - 1].id;
      newItems = await tradeProvider.getLowestRateTrade(
          currency[_idx],
          lastListIdx,
          _address.country,
          _address.administrativeArea,
          _address.subAdministrativeArea,
          _address.locality,
          _address.subLocality,
          _address.thoroughfare);
    }
    setState(() {
      trade.addAll(newItems);
    });
  }

  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Row(
            children: [
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () async {
                  Address address = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseLocationPage2(
                              37.5013068, 127.0396597)));
                  setState(() {
                    _addr = "${address.subLocality} ${address.thoroughfare}";
                    _address = address;
                  });
                  if (_selectedValue == "최신순") {
                    trade = await tradeProvider.getLatestTrade(
                        currency[_idx],
                        null,
                        _address.country,
                        _address.administrativeArea,
                        _address.subAdministrativeArea,
                        _address.locality,
                        _address.subLocality,
                        _address.thoroughfare);
                    setState(() {});
                  } else if (_selectedValue == "낮은 가격순") {
                    trade = await tradeProvider.getLowestTrade(
                        currency[_idx],
                        null,
                        _address.country,
                        _address.administrativeArea,
                        _address.subAdministrativeArea,
                        _address.locality,
                        _address.subLocality,
                        _address.thoroughfare);
                    setState(() {});
                  } else {
                    trade = await tradeProvider.getLowestRateTrade(
                        currency[_idx],
                        null,
                        _address.country,
                        _address.administrativeArea,
                        _address.subAdministrativeArea,
                        _address.locality,
                        _address.subLocality,
                        _address.thoroughfare);
                    setState(() {});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  child: Row(
                    children: [
                      Text(
                        _addr,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  int idx = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 5 * 4,
                            color: Colors.transparent,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              height:
                                  MediaQuery.of(context).size.height / 5 * 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text(
                                    '통화 선택',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      child: ListView.builder(
                                    itemCount: country.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (_selectedValue == "최신순") {
                                            trade = await tradeProvider
                                                .getLatestTrade(
                                                    currency[index],
                                                    null,
                                                    _address.country,
                                                    _address.administrativeArea,
                                                    _address
                                                        .subAdministrativeArea,
                                                    _address.locality,
                                                    _address.subLocality,
                                                    _address.thoroughfare);
                                            setState(() {});
                                          } else if (_selectedValue ==
                                              "낮은 가격순") {
                                            trade = await tradeProvider
                                                .getLowestTrade(
                                                    currency[index],
                                                    null,
                                                    _address.country,
                                                    _address.administrativeArea,
                                                    _address
                                                        .subAdministrativeArea,
                                                    _address.locality,
                                                    _address.subLocality,
                                                    _address.thoroughfare);
                                            setState(() {});
                                          } else {
                                            trade = await tradeProvider
                                                .getLowestRateTrade(
                                                    currency[index],
                                                    null,
                                                    _address.country,
                                                    _address.administrativeArea,
                                                    _address
                                                        .subAdministrativeArea,
                                                    _address.locality,
                                                    _address.subLocality,
                                                    _address.thoroughfare);
                                            setState(() {});
                                          }
                                          setState(() {
                                            _idx = index;
                                          });
                                          if (!mounted) return;
                                          Navigator.pop(context, _idx);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 20),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      country[index],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      currency[index],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                  )),
                                ],
                              ),
                            ));
                      });
                  setState(() {
                    _idx = idx;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/flag/${currency[_idx] == 'KRW' ? 'KRW' : currency[_idx] == 'USD' ? 'USDKRW' : 'USD${currency[_idx]}'}.png'),
                        radius: 10,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        currency[_idx],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          leadingWidth: double.infinity,
          actions: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const NotificationPage();
                    },
                  ));
                },
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.black87)),
            const SizedBox(width: 15),
          ],
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color(0xFFFFD954),
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '매매기준율',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                  '${DateFormat('yyyy.MM.dd HH:mm').format(DateTime.now())} 기준')
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: const Color(0xFFD9D9D9),
                              width: 2,
                            ),
                            color: const Color(0xFFD9D9D9),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 28,
                                height: kMinInteractiveDimension,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  color: Color(0xFFF7F7F7),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/flag/${currency[_idx] == 'KRW' ? 'KRW' : currency[_idx] == 'USD' ? 'USDKRW' : 'USD${currency[_idx]}'}.png'),
                                      radius: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                country[_idx],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                currency[_idx],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('${unit[_idx]}',
                                                  style: const TextStyle(
                                                      fontSize: 15)),
                                              Text(
                                                sign[_idx],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 2,
                                color: const Color(0xFFD9D9D9),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width:
                                    MediaQuery.of(context).size.width / 2 - 48,
                                height: kMinInteractiveDimension,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        currency[_idx] == "USD"
                                            ? '${NumberFormat("#,##0.00").format(exchangeRates!['USDKRW'])} ₩'
                                            : '${NumberFormat("#,##0.00").format(exchangeRates!['USDKRW']! / exchangeRates!['USD${currency[_idx]}']! * unit[_idx])} ₩',
                                        style: const TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedValue,
                        items: _valueList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 17),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            _selectedValue = value!;
                          });
                          if (value == "최신순") {
                            trade = await tradeProvider.getLatestTrade(
                                currency[_idx],
                                null,
                                _address.country,
                                _address.administrativeArea,
                                _address.subAdministrativeArea,
                                _address.locality,
                                _address.subLocality,
                                _address.thoroughfare);
                            setState(() {});
                          } else if (value == "낮은 가격순") {
                            trade = await tradeProvider.getLowestTrade(
                                currency[_idx],
                                null,
                                _address.country,
                                _address.administrativeArea,
                                _address.subAdministrativeArea,
                                _address.locality,
                                _address.subLocality,
                                _address.thoroughfare);
                            setState(() {});
                          } else {
                            trade = await tradeProvider.getLowestRateTrade(
                                currency[_idx],
                                null,
                                _address.country,
                                _address.administrativeArea,
                                _address.subAdministrativeArea,
                                _address.locality,
                                _address.subLocality,
                                _address.thoroughfare);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: trade.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return TransactionDetailPage(trade[index].id);
                                },
                              ));
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(15, 2, 15, 10),
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: ExtendedImage.network(
                                                trade[index].thumbnailImageUrl,
                                                height: 60,
                                                fit: BoxFit.cover)
                                            // Image(
                                            //   height: 60,
                                            //   image:
                                            //   NetworkImage(trade[index]
                                            //       .thumbnailImageUrl,
                                            //   ),
                                            //   // AssetImage(
                                            //   //   "assets/images/ausdollar.jpg",
                                            //   // ),
                                            //   fit: BoxFit.cover,
                                            // )
                                            ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          // height: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                trade[index].title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${trade[index].subLocality} ${trade[index].thoroughfare}',
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  const Text(
                                                    ' · ',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    formatDate(DateTime.parse(trade[index].createTime)),
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/flag/${trade[index].countryCode == 'KRW' ? 'KRW' : trade[index].countryCode == 'USD' ? 'USDKRW' : 'USD${trade[index].countryCode}'}.png'),
                                                    radius: 8,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '${NumberFormat("#,##0").format(trade[index].foreignCurrencyAmount)} ${trade[index].countryCode}',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(3, 2, 3, 2),
                                                    decoration: BoxDecoration(
                                                      color: trade[index]
                                                                  .status ==
                                                              "PROGRESS"
                                                          ? const Color(
                                                              0xFFFFD954)
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                        trade[index].status ==
                                                                "PROGRESS"
                                                            ? "예약 중"
                                                            : " "),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${NumberFormat("#,##0").format(trade[index].koreanWonAmount)}원',
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .favorite_border_rounded,
                                                              size: 17),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                              "${trade[index].tradeLikeCount}"),
                                                        ],
                                                      ),
                                                    ],
                                                  )
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
                          );
                        })),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TransactionPage();
                  },
                ));
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFD954),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ]),
      ),
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
  '\$',
  '₽'
];

List<int> unit = [1, 100, 1, 1, 1, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1];
