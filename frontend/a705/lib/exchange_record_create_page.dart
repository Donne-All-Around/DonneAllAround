import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ExchangeRecordCreatePage extends StatefulWidget {
  const ExchangeRecordCreatePage({super.key});

  @override
  State<ExchangeRecordCreatePage> createState() => ExchangeRecordCreatePageState();
}

class ExchangeRecordCreatePageState extends State<ExchangeRecordCreatePage> {
  final _valueList = [
    '미국(달러) USD',
    '일본(엔) JPY',
    '유럽(유로) EUR',
    '영국(파운드) GBP',
    '호주(달러) AUD',
    '중국(위안) CNY',
    '베트남(동) VND',
    '홍콩(달러) HKD'
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
    'HKD'
  ];
  List<String> sign = ['\$', '¥', '€', '£', '\$', '¥', '₫', '\$'];

  final _banks = ['하나은행', '우리은행', '국민은행', '농협'];
  String _selectedBank = '하나은행';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            elevation: 0,
            title: const Text(
              '나의 환전',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '환전 일시',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        )
                      )
                    )
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
                    height: 60,
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
                          AssetImage('assets/images/flag/USDKRW.png'),
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
                  TextField(
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
                  const SizedBox(height: 15),
                  const Text(
                    '은행',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedBank,
                          items: _banks.map((bank) {
                            return DropdownMenuItem<String>(
                              value: bank,
                              child: Text(bank),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBank = value!;
                            });
                          }
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '우대율',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide:
                          BorderSide(color: Color(0xFFF2F2F2), width: 3),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixText: ' %',
                    ),
                    cursorColor: Colors.black87,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 60,
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
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)
                      )
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}