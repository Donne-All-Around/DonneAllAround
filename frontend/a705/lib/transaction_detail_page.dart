import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {

  @override
  void initState() {
    super.initState();
    loadData();
  }

  final List<Marker> _marker = <Marker>[];
  String image = 'assets/images/marker.png';
  final LatLng latlng = const LatLng(37.5013068, 127.0396597);
  
  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  loadData() async {
    final Uint8List markIcon = await getImages(image, 100);
    _marker.add(
      Marker(
        markerId: const MarkerId('1'),
        icon: BitmapDescriptor.fromBytes(markIcon),
        position: latlng,
        infoWindow: const InfoWindow(
          title: 'Location'
        ),
      )
    );
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
        body: SingleChildScrollView(
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
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                          radius: 35,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '옹골찬',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '호주 달러 50달러 팔아요',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Text('1시간 전'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '7월에 호주 여행 다녀와서 남은 돈이에요 역삼역 근처에서 직거래 희망합니다',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                          Text('강남구 역삼동', style: TextStyle(fontSize: 15),),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 400,
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(37.5013068, 127.0396597),
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
            ],
          ),
        ),
        bottomNavigationBar: ,
      ),
    );
  }
}
