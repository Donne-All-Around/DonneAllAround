import 'package:a705/chatting_detail_page.dart';
import 'package:a705/models/TradeDto.dart';
import 'package:a705/providers/trade_providers.dart';
import 'package:a705/storage.dart';
import 'package:a705/transaction_modify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'home_page.dart';

class TransactionDetailPage extends StatefulWidget {
  final int id;

  const TransactionDetailPage(this.id, {super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  void initState() {
    getTradeDetail();
    loadData();
    super.initState();

  }

  // 내 user id 받아오기
  String myUserId = "";
  bool isMine = false;

  final List<Marker> _marker = <Marker>[];
  String image = 'assets/images/marker.png';
  late LatLng latlng;

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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

  loadData() async {
    final Uint8List markIcon = await getImages(image, 100);
    _marker.add(Marker(
      markerId: const MarkerId('1'),
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: latlng,
      infoWindow: const InfoWindow(title: 'Location'),
    ));
    setState(() {});
  }

  TradeProviders tradeProvider = TradeProviders();
  TradeDto trade = TradeDto(
    id: 0,
    sellerId: 0,
    title: "",
    description: "",
    status: "",
    countryCode: "USD",
    foreignCurrencyAmount: 0,
    koreanWonAmount: 0,
    latitude: 0,
    longitude: 0,
    country: "",
    administrativeArea: "",
    subAdministrativeArea: "",
    locality: "",
    subLocality: "",
    thoroughfare: "",
    type: "",
    tradeLikeCount: 0,
    sellerNickname: "",
    sellerImgUrl: "",
    sellerRating: 0,
    isLike: false,
    createTime: "",
    koreanWonPerForeignCurrency: 0,
    imageUrlList: [],
    thumbnailImageUrl: "",
  );

  Future getTradeDetail() async {
    myUserId = getUserId().toString();
    trade = await tradeProvider.getTradeDetail(widget.id);
    print("trade id: ${trade.id}");
    if (trade.sellerId.toString() == myUserId) {
      isMine = true;
    }
    setState(() {
      latlng = LatLng(trade.latitude, trade.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200.0),
                          child: AlertDialog(
                            content: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return TransactionModifyPage(
                                                  id: trade.id);
                                            },
                                          ));
                                        },
                                        child: const Text(
                                          '수정하기',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.blue),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          tradeProvider.deleteTrade(trade.id);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const HomePage()),
                                              (route) => false);
                                        },
                                        child: const Text(
                                          '삭제하기',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.red),
                                        )),
                                  ],
                                )),
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 30,
                  color: Colors.black,
                )),
            const SizedBox(width: 20),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                      itemCount: trade.imageUrlList.length,
                      pageSnapping: true,
                      itemBuilder: (context, index) {
                        return Image(
                            image: NetworkImage(trade.imageUrlList[index]));
                      }),
                ),
                Container(height: 1, color: Colors.black26),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 18, 30, 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                            radius: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            trade.sellerNickname,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                            'assets/images/level/${trade.sellerRating}.png'),
                      )
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.black26),
                Container(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                trade.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(formatDate(DateTime.parse(trade.createTime))),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                trade.description,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                Text(
                                  '거래 희망 장소',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            Text(
                              '${trade.subLocality} ${trade.thoroughfare}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            // 원하는 둥글기 반경 설정
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: latlng,
                                zoom: 17,
                              ),
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: true,
                              markers: Set<Marker>(),
                              mapToolbarEnabled: false,
                            ),
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: trade.isLike
                              ? const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border_rounded),
                          onPressed: () {
                            setState(() {
                              if (trade.isLike) {
                                tradeProvider.unlikeTrade(widget.id);
                                trade.isLike = false;
                              } else {
                                tradeProvider.likeTrade(widget.id);
                                trade.isLike = true;
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        Container(width: 1, color: Colors.black26),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/flag/${trade.countryCode == 'KRW' ? 'KRW' : trade.countryCode == 'USD' ? 'USDKRW' : 'USD${trade.countryCode}'}.png'),
                                        radius: 8,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${NumberFormat("#,##0").format(trade.foreignCurrencyAmount)} ${trade.countryCode}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${NumberFormat("#,##0").format(trade.koreanWonAmount)}원',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              isMine
                                  ? Column()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ChattingDetailPage(
                                                tradeInfoMap: {
                                                  "tradeId":
                                                      trade.id.toString(),
                                                  "seller":
                                                      trade.sellerNickname,
                                                  "sellerId":
                                                      trade.sellerId.toString(),
                                                });
                                          },
                                        ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5, 20, 5),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD954),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '채팅하기',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
