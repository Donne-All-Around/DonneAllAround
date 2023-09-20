import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:a705/choose_location_page.dart';

class DirectTransactionPage extends StatefulWidget {
  const DirectTransactionPage({super.key});

  @override
  State<DirectTransactionPage> createState() => _DirectTransactionPageState();
}

class _DirectTransactionPageState extends State<DirectTransactionPage> {

  var appointmentDate = DateTime.now();
  String _addr = "장소 선택";
  String appt = "";

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
              onPressed: () {
                setState(() {
                  appt += DateFormat('yy년 MM월 dd일 HH시 mm분').format(appointmentDate);
                  appt += " ";
                  appt += _addr;
                });
                Navigator.pop(context, appt);
                Navigator.pop(context, appt);
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
                          child: const Image(
                            height: 60,
                            image: AssetImage(
                              'assets/images/ausdollar.jpg',
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                    const Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '호주 달러 50달러 팔아요',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/AUD.png'),
                                  radius: 8,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '50 AUD',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '42,000원',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 20),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 50,
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
                    DateFormat('yy년 MM월 dd일 HH시 mm분').format(appointmentDate),
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
                      builder: (context) => const ChooseLocationPage()));
              setState(() {
                _addr = addr;
              });
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 50,
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
                  Text(
                    _addr,
                    style: const TextStyle(
                      fontSize: 15,
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
      minDateTime: DateTime.now(),
      maxDateTime: DateTime.now().add(const Duration(days: 7)),
      initialDateTime: DateTime.now(),
      buttonSingleColor: const Color(0xFFFFD954),
    ).show(context);
  }
}
