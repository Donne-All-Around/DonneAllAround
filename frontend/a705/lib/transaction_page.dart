import 'dart:io';

import 'package:a705/choose_location_page2.dart';
import 'package:a705/main_page.dart';
import 'package:a705/models/address.dart';
import 'package:a705/providers/trade_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a705/models/TradeDto.dart';
import 'package:intl/intl.dart';

// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
// Future<void> signInWithAnonymous() async {
//   UserCredential _credential = await _firebaseAuth.signInAnonymously();
//   if (_credential.user != null) {
//     print(_credential.user!.uid);
//   }
// }

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
  int _currency = 0;

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

  List<String> sign = [
    '\$',
    '¥',
    '€',
    '£',
    '\$',
    '¥',
    '₫',
    '₩',
    '\$',
    '\$',
    'Kč',
    '\$',
    '₱',
    '₽',
    '\$',
    '\$'
  ];

  List<File> selectedImages = [];
  final picker = ImagePicker();

  String _addr = "장소 선택";
  Address _address = Address(
      country: "",
      administrativeArea: "",
      subAdministrativeArea: "",
      locality: "",
      subLocality: "",
      thoroughfare: "",
      latitude: 0,
      longitude: 0);

  @override
  void initState() {
    super.initState();
    // checkPermission();
  }

  TradeProviders tradeProvider = TradeProviders();

  TradeDto uploadTrade = TradeDto(
    id: 0,
    sellerId: 0,
    title: "",
    description: "",
    thumbnailImageUrl: "",
    status: "",
    countryCode: "",
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
  );

  final _titleEditController = TextEditingController();
  final _currencyEditController = TextEditingController();
  final _krwEditController = TextEditingController();
  final _contentEditController = TextEditingController();

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
                          if (selectedImages.isEmpty) {
                            getImages();
                          }
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
                          width: double.infinity,
                          // To show images in particular area only
                          height: 80,
                          child: selectedImages
                                  .isEmpty // If no images is selected
                              ? const Center(child: Text('사진을 선택하세요'))
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
                      controller: _titleEditController,
                      style: const TextStyle(height: 1.4),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: '글 제목',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                      controller: _currencyEditController,
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
                      onChanged: (text) {
                        setState(() {
                          _currency = int.parse(_currencyEditController.text);
                        });
                      },
                    ),
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
                      controller: _krwEditController,
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
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "적정 거래 가격 ${_currency * 90} ~ ${_currency * 100}원",
                        textAlign: TextAlign.end,
                      )),
                    ],
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
                    controller: _contentEditController,
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
                      FocusManager.instance.primaryFocus?.unfocus();
                      Address address = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChooseLocationPage2(
                                  37.5013068, 127.0396597)));
                      setState(() {
                        _addr =
                            "${address.subLocality} ${address.thoroughfare}";
                        _address = address;
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
                  GestureDetector(
                    onTap: () async {
                      // if (!mounted) return;
                      if (selectedImages.isEmpty ||
                          _titleEditController.text.isEmpty ||
                          _currencyEditController.text.isEmpty ||
                          _krwEditController.text.isEmpty ||
                          _contentEditController.text.isEmpty ||
                          _addr == "장소 선택") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    child: const Text(
                                      "빈 칸이 없이 모두 입력해주세요.",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("확인"))
                                ],
                              );
                            });
                      } else {
                        uploadTrade = TradeDto(
                          id: uploadTrade.id,
                          sellerId: uploadTrade.sellerId,
                          title: _titleEditController.text,
                          description: _contentEditController.text,
                          thumbnailImageUrl: uploadTrade.imageUrlList[0],
                          status: uploadTrade.status,
                          countryCode: _selectedValue,
                          foreignCurrencyAmount:
                              int.parse(_currencyEditController.text),
                          koreanWonAmount: int.parse(_krwEditController.text),
                          latitude: _address.latitude,
                          longitude: _address.longitude,
                          country: _address.country!,
                          administrativeArea: _address.administrativeArea!,
                          subAdministrativeArea:
                              _address.subAdministrativeArea!,
                          locality: _address.locality!,
                          subLocality: _address.subLocality!,
                          thoroughfare: _address.thoroughfare!,
                          type: uploadTrade.type,
                          tradeLikeCount: uploadTrade.tradeLikeCount,
                          sellerNickname: uploadTrade.sellerNickname,
                          sellerImgUrl: uploadTrade.sellerImgUrl,
                          sellerRating: uploadTrade.sellerRating,
                          isLike: uploadTrade.isLike,
                          createTime: uploadTrade.createTime,
                          koreanWonPerForeignCurrency:
                              uploadTrade.koreanWonPerForeignCurrency,
                          imageUrlList: uploadTrade.imageUrlList,
                        );

                        tradeProvider.postTrade(uploadTrade);

                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                            (route) => false);
                      }
                    },
                    child: Container(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                    ),
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
    DateTime now = DateTime.now();
    final String _dateTime = DateFormat('yyMMdd-HHmmss').format(now);
    setState(() {
      if (xfilePick.isNotEmpty) {
        for (var i = 0; i < xfilePick.length; i++) {
          File _file = File(xfilePick[i].path);
          selectedImages.add(_file);
        }
      }
    });
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < selectedImages.length; i++) {
        String _path =
            "trade/${uploadTrade.sellerId}/image_${_dateTime}_$i.jpg";
        File _file = File(xfilePick[i].path);
        await FirebaseStorage.instance.ref(_path).putFile(_file);
        final String _urlString =
            await FirebaseStorage.instance.ref(_path).getDownloadURL();
        uploadTrade.imageUrlList.add(_urlString);
        print(_urlString);
      }
    }
  }
}
