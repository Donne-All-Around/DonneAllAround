import 'package:flutter/material.dart';
import 'package:a705/transaction_detail_page.dart';


class BuyRecordPage extends StatefulWidget {
  const BuyRecordPage({super.key});

  @override
  State<BuyRecordPage> createState() => BuyRecordPageState();
}

class BuyRecordPageState extends State<BuyRecordPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                '구매 내역',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
            ),
            centerTitle: true,
          ),
          body : Stack(children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: const Column(
                children: [
                  Expanded(child: ListViewBuilder()),
               ]
              )
            )
          ])
        )
    );
  }
}

List<String> transactions = ['별의 커비', '뽀로로'];

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {

  void _handleDelete() {
    // 삭제 작업 코드
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const TransactionDetailPage();
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 2, 15, 10),
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          // height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '호주 달러 50달러 팔아요',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child : PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.black,
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('삭제하기'),
                                          )
                                        ];
                                      },
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          _handleDelete();
                                        }
                                      }
                                    )
                                  )
                                ]
                              ),
                              const Row(
                                children: [
                                  Text(
                                    '강남구 역삼동',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Text(
                                    ' · ',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Text(
                                    '1시간 전',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                    AssetImage('assets/images/USDAUD.png'),
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
                              const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '42,000원',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 350,
                    height: 35,
                    margin: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        // '후기 작성' 버튼을 눌렀을 때 수행할 동작 추가
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD954),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        '후기 작성',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}