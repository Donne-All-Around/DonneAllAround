import 'dart:io';

import 'package:a705/choose_location_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _valueList = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '한국(원) KRW',
    '홍콩(달러) HKD',
    '캐나다(달러) CAD',
    '체코(코루나) CZK',
    '뉴질랜드(달러) NZD',
    '필리핀(페소) PHP',
    '러시아(루블) RUB',
    '싱가폴(달러) SGD',
    '대만(달러) TWD',
  ];
  var _selectedValue = '미국(달러) USD';
  int idx = 0;

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

  List<File> selectedImages = [];
  final picker = ImagePicker();

  String _addr = "장소 선택";

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
  //     print("currentPosition: ${currentPosition.longitude}");
  //
  //   });
  // }

  // late LatLng currentPosition;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              '판매글 등록',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImages();
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFF3F3F3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_outlined),
                              Text("${selectedImages.length}/10"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // To show images in particular area only
                          height: 80,
                          child: selectedImages
                              .isEmpty // If no images is selected
                              ? const Center(
                              child: Text('사진을 선택하세요'))
                          // If at least 1 images is selected
                              : GridView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const ScrollPhysics(),
                            itemCount: selectedImages.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1 / 1,
                              mainAxisSpacing: 10,
                              // Horizontally only 3 images will show
                            ),
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: kIsWeb
                                        ? Image.network(
                                      selectedImages[index].path,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.file(
                                      selectedImages[index],
                                      width: 80,
                                      fit: BoxFit.cover,
                                    )),
                              );

                              // If you are making the web app then you have to
                              // use image provider as network image or in
                              // android or iOS it will as file only
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '제목',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      style: const TextStyle(height: 1.4),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: '글 제목',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      cursorColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '화폐 종류',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedValue,
                            items: _valueList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/flag/${currency[_valueList.indexOf(value)]}.png'),
                                      radius: 10,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(value),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                idx = _valueList.indexOf(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                        ),
                        suffixText: ' ${sign[idx]}',
                      ),
                      cursorColor: Colors.black87,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("거래 가격 "),
                      Text("100,000~120,000원"),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '가격',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/images/flag/KRW.png'),
                          radius: 10,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '대한민국(원화) KRW',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixText: ' ₩',
                      ),
                      cursorColor: Colors.black87,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '설명',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: '설명을 입력하세요',
                      filled: true,
                      fillColor: const Color(0xFFF2F2F2),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    cursorColor: Colors.black87,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '거래 희망 장소',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height: _addr == "장소 선택" ? 50 : null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _addr,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFFFD954),
                    ),
                    child: const Center(
                        child: Text(
                          '작성 완료',
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage();
    List<XFile> xfilePick = pickedFile;

    setState(() {
      if (xfilePick.isNotEmpty) {
        for (var i = 0; i < xfilePick.length; i++) {
          selectedImages.add(File(xfilePick[i].path));
        }
      }
    });
  }
}