import 'package:a705/service/database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kpostal/kpostal.dart';

import 'chatting_detail_page.dart';
import 'chatting_page.dart';

class DeliveryTransactionPage extends StatefulWidget {
  final Map<String, dynamic>? tradeInfoMap;

  DeliveryTransactionPage({Key? key, required this.tradeInfoMap})
      : super(key: key);

  @override
  State<DeliveryTransactionPage> createState() =>
      _DeliveryTransactionPageState();
}

class _DeliveryTransactionPageState extends State<DeliveryTransactionPage> {
  String postCode = '';
  String address = '';
  String deliveryAddressDetail = "";
  String deliveryRecipientTel = "";
  String deliveryRecipientName = "";
  String sellerAccountBankCode = "";
  String sellerAccountNumber = "";
  String trackingNumber = "";

  var appointmentDate = DateTime.now();
  String _addr = "장소 선택";
  String appt = "";
  String _addrDetail = "";

  bool showEdit() {
    AppointmentType apptType = widget.tradeInfoMap?['appointmentType'];
    if (apptType == AppointmentType.completeDeliverySeller ||
        apptType == AppointmentType.completeDeliveryBuyer) {
      return false;
    }
    return true;
  }

  bool showEditDetailAddr() {
    AppointmentType apptType = widget.tradeInfoMap?['appointmentType'];
    if (apptType == AppointmentType.completeDeliverySeller ||
        apptType == AppointmentType.completeDeliveryBuyer) {
      return false;
    }
    if (_addr == "장소 선택") {
      return false;
    }
    return true;
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    print("${widget.tradeInfoMap.toString()}");
    String? deliveryAddr = widget.tradeInfoMap?['deliveryAddress'];
    if (deliveryAddr != null && deliveryAddr != "") {
      _addr = "$deliveryAddr";
    }
    deliveryRecipientName = widget.tradeInfoMap?['deliveryRecipientName'] ?? '';
    deliveryAddressDetail = widget.tradeInfoMap?['deliveryAddressDetail'] ?? '';
    deliveryRecipientTel = widget.tradeInfoMap?['deliveryRecipientTel'] ?? '';
    sellerAccountNumber = widget.tradeInfoMap?['sellerAccountNumber'] ?? '';
    sellerAccountBankCode = widget.tradeInfoMap?['sellerAccountBankCode'] ?? '';
    trackingNumber = widget.tradeInfoMap?['trackingNumber'] ?? '';
  }

  @override
  void dispose() {
    _addrTextEditController.dispose();
    super.dispose();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  late LatLng currentPosition;

  final _addrTextEditController = TextEditingController();

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
          '택배 거래',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (showEdit()) {
                  setState(() {});
                  // 택배거래 약속잡기
                  addDeliveryApptData();
                }

                Navigator.pop(
                  context,
                );
              },
              icon: const Icon(
                Icons.check_rounded,
                color: Colors.black,
              )),
        ],
      ),
      body: Column(
        children: <Widget>[
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
              children: <Widget>[
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
                          child: const Image(
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
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 39),
                    Text(
                      '배송지',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: showEdit()
                      ? () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KpostalView(
                                useLocalServer: true,
                                localPort: 8080,
                                kakaoKey: '0c75e0af40aaa0554ca69939967756ed',
                                callback: (Kpostal result) {
                                  setState(() {
                                    postCode = result.postCode;
                                    address = result.address;
                                  });
                                },
                              ),
                            ),
                          );
                          if (postCode != null && postCode != "") {
                            setState(() {
                              _addr = "($postCode) ";
                              _addr += address;
                            });
                          }
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
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
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                            initialValue: deliveryAddressDetail,
                            // controller: _addrTextEditController,
                            decoration: InputDecoration(
                              hintText: '상세주소를 입력하세요',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              enabled: showEditDetailAddr(),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            onChanged: (text) {
                              _addrDetail = text;
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 39),
                    Text(
                      '택배 수령인',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: deliveryRecipientName,
                          decoration: InputDecoration(
                            hintText: '수령인의 이름을 입력하세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            enabled: showEdit(),
                          ),
                          onChanged: (text) {
                            deliveryRecipientName = text;
                          },
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 39),
                    Text(
                      '택배 수령인 전화번호',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: deliveryRecipientTel,
                          decoration: InputDecoration(
                            hintText: '수령인의 전화번호를 입력하세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            enabled: showEdit(),
                          ),
                          onChanged: (text) {
                            deliveryRecipientTel = text;
                          },
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 39),
                    Text(
                      '판매자 계좌 번호',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: sellerAccountNumber,
                          decoration: InputDecoration(
                            hintText: '판매자의 계좌 번호를 입력하세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            enabled: showEdit(),
                          ),
                          onChanged: (text) {
                            sellerAccountNumber = text;
                          },
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 39),
                        Text(
                          '송장번호',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: trackingNumber,
                              decoration: InputDecoration(
                                hintText: '택배 송장번호를 입력하세요',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                enabled: showEdit(),
                              ),
                              onChanged: (text) {
                                trackingNumber = text;
                              },
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    ));
  }

  void addDeliveryApptData() {
    Map<String, dynamic> tradeInfo = {
      "type": "DELIVERY",
      "directTradeTime": null,
      "directTradeLocationDetail": null,
      "sellerAccountBankCode": null,
      "sellerAccountNumber": sellerAccountNumber,
      "deliveryRecipientName": deliveryRecipientName,
      "deliveryRecipientTel": deliveryRecipientTel,
      "deliveryAddressZipCode": postCode,
      "deliveryAddressDetail": _addrDetail,
      "deliveryAddress": _addr,
      "trackingNumber": trackingNumber,
      "buyerId": widget.tradeInfoMap?['buyerId'],
      "sellerId": myUserId,
      "method": "ACCOUNT",
      "isRemittance": false,
      "status": "PROGRESS",
      "sellerReview": false,
      "buyerReview": false,
    };
    DatabaseMethods().setTradeInfo(widget.tradeInfoMap?['tradeId'], tradeInfo);
    print(tradeInfo.toString());
  }
}
