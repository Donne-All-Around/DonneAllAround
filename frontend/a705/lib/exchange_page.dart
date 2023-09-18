import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');
    var strToday = formatter.format(now);
    return strToday;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
                children: [
                  // 상단 바 (환율 검색)
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color(0xFFFFD954),
                    ),
                    child:  Center(
                      child: RichText(
                        text: const TextSpan(
                          children:  [
                            TextSpan(
                              text: "환율",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            TextSpan(
                              text: " 검색",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        // textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // body 페이지
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    width: double.infinity,
                    height: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black38),
                    ),
                    child:Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20,40, 10),
                              padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                              width: 230,
                              height: 40,
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
                                iconSize: 40,
                                color: Colors.grey,),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                              width: 150,
                              height: 20,
                              // color: Colors.red,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                        backgroundColor: Colors.green
                                    ),

                                      child: const Text('직접',),),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                      onPressed:(){},
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('이중') ),
                                ],
                              ),
                            ),
                          ],
                        ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                width: 340,
                                height: 60,
                                // color: Colors.red,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black38),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              width: 340,
                              height: 60,
                              // color: Colors.red,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black38),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(270, 10, 10, 0),
                            width: 70,
                            height: 50,
                            // color: const Color(0xFFFFD954),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(color: Colors.black38),
                              color:  const Color(0xFFFFD954),
                            ),
                            child:IconButton(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                              onPressed: (){},
                              icon: const Icon(Icons.drag_handle_rounded),
                              iconSize: 50,
                              color: Colors.white,

                            ),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                  // 말풍선
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                        width: 350,
                        height: 60,
                        child: getSenderView(
                            ChatBubbleClipper6(type: BubbleType.sendBubble), context),
                      ),
                    ],
                  ),
                 //국가별 실시간 환율
                     GestureDetector(
                       // 상세페이지 이동
                       onTap: (){} ,
                       child: Row(
                         children: [
                           Container(
                             margin: const EdgeInsets.fromLTRB(25, 10, 20, 0),
                             width: 360,
                             height: 50,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20),
                               border: Border.all(color: Colors.black38),
                             ),
                             child:
                             const Row(
                               children: [
                                 SizedBox(width: 30,),
                                  CircleAvatar(
                                   backgroundImage: AssetImage('assets/images/australia.png',),
                                   radius: 17,
                                 ),
                                 Text('  호주 (달러)' , style: TextStyle(fontSize: 17),),
                                 Text(' AUD',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                 SizedBox(width: 60,),
                                 Text('853.73원',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                  GestureDetector(
                    // 상세페이지 이동
                    onTap: (){} ,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 10, 20, 0),
                          width: 360,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black38),
                          ),
                          child:
                          const Row(
                            children: [
                              SizedBox(width: 30,),
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/australia.png',),
                                radius: 17,
                              ),
                              Text('  호주 (달러)' , style: TextStyle(fontSize: 17),),
                              Text(' AUD',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                              SizedBox(width: 60,),
                              Text('853.73원',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // 상세페이지 이동
                    onTap: (){} ,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 10, 20, 0),
                          width: 360,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black38),
                          ),
                          child:
                          const Row(
                            children: [
                              SizedBox(width: 30,),
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/australia.png',),
                                radius: 17,
                              ),
                              Text('  호주 (달러)' , style: TextStyle(fontSize: 17),),
                              Text(' AUD',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                              SizedBox(width: 60,),
                              Text('853.73원',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // 상세페이지 이동
                    onTap: (){} ,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 10, 20, 0),
                          width: 360,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black38),
                          ),
                          child:
                          const Row(
                            children: [
                              SizedBox(width: 30,),
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/australia.png',),
                                radius: 17,
                              ),
                              Text('  호주 (달러)' , style: TextStyle(fontSize: 17),),
                              Text(' AUD',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                              SizedBox(width: 60,),
                              Text('853.73원',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // 상세페이지 이동
                    onTap: (){} ,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 10, 20, 0),
                          width: 360,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black38),
                          ),
                          child:
                          const Row(
                            children: [
                              SizedBox(width: 30,),
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/australia.png',),
                                radius: 17,
                              ),
                              Text('  호주 (달러)' , style: TextStyle(fontSize: 17),),
                              Text(' AUD',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                              SizedBox(width: 60,),
                              Text('853.73원',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                            ],
                          ),
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

   // 말풍선
  getSenderView(CustomClipper clipper, BuildContext context) => ChatBubble(
    clipper: clipper,
    elevation: 0,
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.all(0),
    backGroundColor:const Color(0xFFFFD954),
    child: Container(
      // constraints: const BoxConstraints(
      //   // maxWidth: MediaQuery.of(context).size.width * 1,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Text(
            " 국가별 실시간 환율",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            "을 확인 할 수 있어요! ",
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
        ],
      ),
    ),
  );
}
