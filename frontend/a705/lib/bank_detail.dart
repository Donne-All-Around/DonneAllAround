import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankDetailPage extends StatefulWidget {
  const BankDetailPage({super.key});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  
  final _bankList = ['신한은행', '하나은행'];
  var _selectedValue = '신한은행';

  Map<String, Map<String, String>> bankInfo = {
    '신한은행': {'imagePath': 'assets/images/USD.png', 'currencyName': '신한은행'},
    '하나은행': {
      'imagePath': 'assets/images/AUD.png',
      'currencyName': '하나은행'
    },
    
  };

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
  }

  final _valueList = ['미국', '호주', '일본'];
  var _selectedValue1 = '미국';
  var _selectedValue2 = '호주';

  Map<String, Map<String, String>> currencyInfo = {
    '미국': {'imagePath': 'assets/images/USD.png', 'currencyName': '미국 (달러) USD'},
    '호주': {
      'imagePath': 'assets/images/AUD.png',
      'currencyName': '호주 (달러) AUD'
    },
    '일본': {'imagePath': 'assets/images/JPY.png', 'currencyName': '일본 (엔) JPY'},
  };

  // 텍스트 필드 컨트롤러
  final TextEditingController _moneyController = TextEditingController(text: "1");



  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
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
              '환율 검색',
                style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          ),
          body: SingleChildScrollView(
            child:Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  width: 370,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 368,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              border: Border.all(color: Colors.transparent),
                              color: const Color(0xFFFFD954),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.fromLTRB(10, 10, 30, 10),
                                  width: 170,
                                  height: 55,
                                  // color: Colors.red,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _selectedValue,
                                      items: _bankList.map(
                                            (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  bankInfo[value]![
                                                  'imagePath']!,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(bankInfo[value]![
                                                'currencyName']!,
                                                style: TextStyle(fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0,50, 10),
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: 220,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: Text(
                              getToday(),
                              style: const TextStyle(fontSize: 25),),
                          ),
                          const SizedBox(width: 20,),
                          IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.cached_rounded),
                            iconSize: 35,
                            color: Colors.grey,),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                            width: 340,
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
                              '1,000.00 ₩',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: 350,
                            height: 60,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38),
                            ),
                            // 드롭다운
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 172,
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                    border: Border.all(color: Colors.transparent),
                                    color:  Colors.grey[200],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _selectedValue1,
                                      items: _valueList.map(
                                            (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  currencyInfo[value]![
                                                  'imagePath']!,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(currencyInfo[value]![
                                                'currencyName']!),
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue1 = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                    border: Border.all(color: Colors.transparent),
                                  ),
                                  child: TextFormField(
                                    controller: _moneyController,
                                    style: const TextStyle(decorationThickness: 0),
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent)
                                      ),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: 350,
                            height: 60,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38),
                            ),
                            // 드롭다운
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 172,
                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                    border: Border.all(color: Colors.transparent),
                                    color:  Colors.grey[200],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _selectedValue2,
                                      items: _valueList.map(
                                            (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  currencyInfo[value]![
                                                  'imagePath']!,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(currencyInfo[value]![
                                                'currencyName']!),
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue2 = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                                    border: Border.all(color: Colors.transparent),
                                  ),
                                  child: TextFormField(
                                    controller: _moneyController,
                                    style: const TextStyle(decorationThickness: 0),
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent)
                                      ),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
          ],
        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
