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
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.width / 2 - 75,
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
                              image: AssetImage('assets/images/wagon_box.png'),
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
                    ],
                  ),
                ],
              ),
            )));
  }
}
