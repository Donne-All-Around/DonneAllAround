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

  Map<String, Map<String, String>> currencyInfo = {
    '신한은행': {'imagePath': 'assets/images/usa.png', 'currencyName': '신한은행'},
    '하나은행': {
      'imagePath': 'assets/images/australia.png',
      'currencyName': '하나은행'
    },
    
  };

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
  }

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
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  width: 350,
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
                            width: 348,
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
                                                  currencyInfo[value]![
                                                  'imagePath']!,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(currencyInfo[value]![
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
                            margin: const EdgeInsets.fromLTRB(10, 0,30, 10),
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
                          const SizedBox(width: 10,),
                          IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.cached_rounded),
                            iconSize: 35,
                            color: Colors.grey,),
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
