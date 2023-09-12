import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

class ChattingDetailPage extends StatefulWidget {
  const ChattingDetailPage({super.key});

  @override
  State<ChattingDetailPage> createState() => _ChattingDetailPageState();
}

class _ChattingDetailPageState extends State<ChattingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
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
              '옹골찬',
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 2, 20, 10),
                width: double.infinity,
                // height: 100,
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
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                    height: 1.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/images/australia.png'),
                                          radius: 12,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '50 AUD',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '42,000원',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 15),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      height: 30,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Color(0xFFFFD954),
                      ),
                      child: const Center(
                          child: Text(
                        '약속 잡기',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: ListViewBuilder(),
              ),
              Container(
                color: const Color(0xFFFFD954),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const IconButton(
                      icon: Icon(Icons.add),
                      onPressed: null,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: const TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 10, 10, 0),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '메세지를 입력하세요',
                              labelStyle: TextStyle(color: Colors.black87),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                    const IconButton(
                      icon: Icon(Icons.send),
                      onPressed: null,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              )
            ],
          )),
    ));
  }
}

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: chatList.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 00),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BubbleSpecialOne(
                          text: chatList[index],
                          isSender: false,
                          color: Colors.grey.shade200,
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15
                          ),
                        ),
                        const Text('오후 10: 10',
                          style: TextStyle(
                            fontSize: 10,
                          )
                        )
                      ],
                    )
                  )
                ],
              )
            )
          ],
        );
      },
    );
  }
}

List<String> chatList = ["흰 티에 청바지 입고있어요", "역삼역 1번출구 앞에서 직거래 희망합니다", "3시에 거래 가능할까요"];