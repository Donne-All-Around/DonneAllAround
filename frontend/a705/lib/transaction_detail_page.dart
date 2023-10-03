import 'dart:typed_data';

import 'package:a705/chatting_detail_page.dart';
import 'package:a705/chatting_page.dart';
import 'package:a705/models/TradeDto.dart';
import 'package:a705/providers/trade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

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

  final List<Marker> _marker = <Marker>[];
  String image = 'assets/images/marker.png';
  final LatLng latlng = const LatLng(37.5013068, 127.0396597);

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
    thumbnailImageUrl: "",
    status: "",
    countryCode: "USD",
    foreignCurrencyAmount: 0,
    koreanWonAmount: 0,
    latitude: 0,
    longitude: 0,
    preferredTradeCountry: "",
    preferredTradeCity: "",
    preferredTradeDistrict: "",
    preferredTradeTown: "",
    tradeLikeCount: 0,
    sellerNickname: "",
    sellerImgUrl: "",
    sellerRating: 0,
    isLike: false,
    createTime: "",
    koreanWonPerForeignCurrency: 0,
    imageUrlList: [],
  );

  Future getTradeDetail() async {
    trade = await tradeProvider.getTradeDetail(widget.id);
    print("trade id: ${trade.id}");
    setState(() {});
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
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                    child: Image(
                  image: AssetImage('assets/images/ausdollar.jpg'),
                )),
                Container(height: 1, color: Colors.black26),
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  color: Colors.white,
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
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.black26),
                Container(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              trade.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            const Text('1시간 전'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              trade.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                              '${trade.preferredTradeDistrict} ${trade.preferredTradeTown}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 400,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(trade.latitude, trade.longitude),
                              zoom: 17,
                            ),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            markers: Set<Marker>.of(_marker),
                            mapToolbarEnabled: false,
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
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black26),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
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
                              if(trade.isLike) {
                                tradeProvider.unlikeTrade(widget.id);
                                trade.isLike = false;
                              }
                              else {
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
                                      const CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/images/flag/AUD.png'),
                                        radius: 8,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${trade.foreignCurrencyAmount} ${trade.countryCode}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${trade.koreanWonAmount}원',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return  const ChattingDetailPage(
                                          transactionInfoMap :{
                                            "transactionId" : "board2",
                                            "transactionTitle" : "싸게싸게팔아요",
                                            "seller" : "신짱구",
                                            "sellerId" : "098765",
                                            "countryCode": "USD",
                                            "transactionUrl" : "",
                                            "koreanWonAmount" : 50000,
                                            "foreignCurrencyAmount" : 5000,
                                            "type": "DIRECT",
                                            "status": "WAIT"
                                          }
                                      );
                                    },
                                  ));
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 5, 20, 5),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD954),
                                    borderRadius: BorderRadius.circular(15),
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
