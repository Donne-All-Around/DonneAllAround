import 'package:a705/providers/trade_providers.dart';
import 'package:a705/transaction_detail_page.dart';
import 'package:a705/transaction_page.dart';
import 'package:a705/notification_page.dart';
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

  int size = -1;

  Future initTrade() async {
    trade = await tradeProvider.getLatestTrade(
        currency[_idx], null, null, null, null, null, null, null);
    size = trade.length;
    setState(() {});
  }


  @override
  void initState() {
    initTrade();
    super.initState();
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
      longitude: 127.0396597,);

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
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    '통화 선택',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(child: CountryListViewBuilder()),
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
                                      backgroundImage: AssetImage('assets/images/flag/${currency[_idx] == 'KRW' ? 'KRW' : currency[_idx] == 'USD' ? 'USDKRW' : 'USD${currency[_idx]}'}.png'),
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('1300 ₩',
                                        style: TextStyle(fontSize: 15)),
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
                          }
                          else if (value == "낮은 가격순") {
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
                          }
                          else {
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
                                            child: Image(
                                              height: 60,
                                              image: 
                                                  NetworkImage(trade[index].thumbnailImageUrl),
                                              // AssetImage(
                                              //   "assets/images/ausdollar.jpg",
                                              // ),
                                              fit: BoxFit.cover,
                                            )),
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
                                                  const Text(
                                                    '1시간 전',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/flag/${trade[index].countryCode}.png'),
                                                    radius: 8,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '${trade[index].foreignCurrencyAmount} ${trade[index].countryCode}',
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
                                                        '${trade[index].koreanWonAmount}원',
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
                                      )
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
List<String> currency = [
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
List<String> sign = ['\$', '₩', '¥', '¥','€', '£', '\$', '\$', '\$', '₱', '₫', '\$', '\$','Kč', '\$' '₽' ];

List<int> unit = [1, 1, 100, 1, 1, 1, 1, 1, 1, 1, 100, 1, 1, 1, 1, 1];


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
                      backgroundImage: AssetImage('assets/images/flag/${currency[index] == 'KRW' ? 'KRW' : currency[index] == 'USD' ? 'USDKRW' : 'USD${currency[index]}'}.png'),
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
