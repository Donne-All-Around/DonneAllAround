import 'package:a705/chatting_page.dart';
import 'package:a705/service/database.dart';
import 'package:a705/service/spring_api.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:a705/choose_location_page.dart';

class DirectTransactionPage extends StatefulWidget {
  final Map<String, dynamic>? tradeInfoMap;
  const DirectTransactionPage({Key? key, required this.tradeInfoMap}) : super(key: key);

  @override
  State<DirectTransactionPage> createState() => _DirectTransactionPageState();
}

class _DirectTransactionPageState extends State<DirectTransactionPage> {

  var appointmentDate = DateTime.now().add(Duration(hours: 9));
  String _addr = "장소 선택";
  String appt = "";

  // Future<Position> getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   Position position =
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   return position;
  // }

  @override
  void initState() {
    super.initState();

    // _getUserLocation();
  }

  // void _getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //           accuracy: LocationAccuracy.bestForNavigation));
  //
  //   setState(() {
  //     currentPosition = LatLng(position.latitude, position.longitude);
  //   });
  // }
  //
  // late LatLng currentPosition;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              '약속 잡기',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: isSelectedAddr() ? () {
                    setState(() {
                      appt += DateFormat('yy.MM.dd a hh:mm', 'ko').format(appointmentDate);
                      appt += " ";
                      appt += _addr;
                    });
                    // 직거래 약속 data 추가
                    addDirectApptData();

                    Navigator.pop(context, appt);
                    Navigator.pop(context, appt);
                  } : (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // title: Text("안내"),
                          content: Text("약속 장소를 선택해주세요."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                    context); // Close the dialog
                              },
                              child: Text("확인"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                  )),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 2, 20, 10),
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
                          height: 70,
                          width: 70,
                          margin: const EdgeInsets.fromLTRB(20, 15, 10, 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child:  Image(
                                height: 60,
                                image: AssetImage(
                                  // widget.tradeInfoMap?['thumbnailImageUrl'] ??
                                  'assets/images/ausdollar.jpg',
                                ),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tradeInfoMap?['tradeTitle'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/flag/AUD.png'),
                                              radius: 8,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${NumberFormat.decimalPattern().format(widget.tradeInfoMap?['foreignCurrencyAmount'].toInt())} ${widget.tradeInfoMap?['countryCode']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueAccent),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${NumberFormat.decimalPattern().format(widget.tradeInfoMap?['koreanWonAmount'].toInt())}원',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ],
                                    ),
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
              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30),
                  Text(
                    '약속 시간',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _openDateTimePicker(context);
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('yyyy년 MM월 dd일 a hh시 mm분', 'ko').format(appointmentDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 30),
                  Text(
                    '거래 희망 장소',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  String addr = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseLocationPage(37.5013068, 127.0396597)));
                  setState(() {
                    _addr = addr;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _addr,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _openDateTimePicker(BuildContext context) {
    BottomPicker.dateTime(
      title: '날짜를 선택하세요',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.black,
      ),
      onSubmit: (date) {
        setState(() {
          appointmentDate = date;
        });
      },
      iconColor: Colors.black,
      minDateTime: DateTime.now().add(Duration(hours: 9)),
      maxDateTime: DateTime.now().add(Duration(days: 7, hours: 9)),
      initialDateTime: DateTime.now().add(Duration(hours: 9)),
      buttonSingleColor: const Color(0xFFFFD954),
    ).show(context);
  }

  void addDirectApptData() {
    Map<String, dynamic> tradeInfo = {
      "type": "DIRECT",
      "directTradeTime":  DateFormat('yyyy년 MM월 dd일 a hh시 mm분', 'ko').format(appointmentDate),
      "directTradeLocationDetail": _addr,
      "sellerAccountBankCode": null,
      "sellerAccountNumber": null,
      "deliveryRecipientName": null,
      "deliveryRecipientTel": null,
      "deliveryAddressZipCode": null,
      "deliveryAddressDetail": null,
      "deliveryAddress": null,
      "trackingNumber": null,
      "buyerId": widget.tradeInfoMap?['buyerId'],
      "sellerId": myUserId,
      "method": null,
      "isRemittance": null,
      "status": "PROGRESS",
    };

    /**
     * buyerId 수정 필요
     */
    Map<String, dynamic> setDirectAppointmentMap = { "buyerId" : 2};
    SpringApi().setDirectAppointment(setDirectAppointmentMap, widget.tradeInfoMap?['tradeId'], myUserId!);

    DatabaseMethods().setTradeInfo(widget.tradeInfoMap?['tradeId'], tradeInfo);
    print(tradeInfo.toString());
  }

  bool isSelectedAddr(){
    if(_addr == "장소 선택"){
      return false;
    }else{
      return true;
    }
  }
}
