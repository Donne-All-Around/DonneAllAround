import 'package:a705/delivery_transaction_page.dart';
import 'package:flutter/material.dart';

import 'package:a705/direct_transaction_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String appt = "약속 잡기";

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
                  Navigator.pop(context, appt);
                },
              ),
              elevation: 0,
              title: const Text(
                '약속 잡기',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Container(
              margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Row(
                    children: [
                      Text(
                        '원하는',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '거래 방법',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.yellow[600],
                        ),
                      ),
                      const Text(
                        '을',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        '선택해주세요',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const DirectTransactionPage();
                            },
                          ));
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              height:
                                  MediaQuery.of(context).size.width / 2 - 75,
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
                              child: const Image(
                                image: AssetImage('assets/images/500.png'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '직거래',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const DeliveryTransactionPage();
                            },
                          ));
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              height:
                                  MediaQuery.of(context).size.width / 2 - 75,
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
                              child: const Image(
                                image:
                                    AssetImage('assets/images/wagon_box.png'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '택배 거래',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '택배 거래',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '택배거래를 진행하게 되면,',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '배송 후 구매자에게 ',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '수령 확인',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '을 받아야 합니다.',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '수령확인이 완료된 시점',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '에',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '송금',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '이 이루어집니다.',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              '단, 수령확인을 하지 않아도',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                            Row(
                          children: [
                            Text(
                              '7일 후',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '에는 ',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '반드시 송금',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '이 이루어집니다.',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
