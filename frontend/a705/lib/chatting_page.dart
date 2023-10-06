import 'package:a705/providers/database.dart';
import 'package:a705/storage.dart';
import 'package:flutter/material.dart';

import 'package:a705/chatting_detail_page.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  Map<String, Map<String, String>> items = {};
  Map<String, dynamic> chatroom = {};
  dynamic? lastMessage = "", ts = "";

  // 초기화
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color(0xFFFFD954),
            ),
            child: const Center(
              child: Text(
                "채팅",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // const SizedBox(height: 10),

          const Expanded(child: ListViewBuilder()),
        ],
      ),
    ));
  }
}

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

// 내 정보
String? myUserName, // 내 닉네임
    myProfilePic, // 내 프로필
    myPhone, // 내 번호
    messageId, // 메시지 아이디
    chatRoomId, // 채팅방 아이디
    otherUserName, // 상대방 닉네임
    seller, // 판매자 닉네임
    buyer, // 구매자 닉네임
    transactionId, // 거래글 아이디
    otherImgUrl,
    myRole,
    otherRole,
    myUserId,
    otherUserId;
String transactionUrl = 'assets/images/ausdollar.jpg';
int? unRead; // 안 읽음 개수
bool isExit = false; // 나감 여부
bool isRead = false; // 읽음 여부
Map<String, Map<String, String>> items = {};
Map<String, dynamic> chatroom = {};
dynamic? lastMessage = "", ts = "";
bool isChatroomExits = false;

class _ListViewBuilderState extends State<ListViewBuilder> {
  Map<String, dynamic> chatroom = {}; // chatroom 맵을 이 클래스로 옮깁니다.

  // ListViewBuilder가 초기화될 때 chatroom 데이터를 가져오도록 initState를 사용합니다.
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getAndSetChatrooms();
  }

  getUserInfo() async {
    myUserName = await getUserNickname();
    myUserId = await getUserId().toString();
    // myUserName = "룰루랄라";
    // myUserId = "31";
    // myUserName = "전정국";
    // myUserId = "32";
    setState(() {});
  }

  // getAndSetChatrooms() 메서드는 이 클래스 내에서 정의합니다.
  Future<List> getAndSetChatrooms() async {
    print('myUserId : ${myUserId}');
    List<String> myList = await DatabaseMethods().getUserChatList(myUserId!);
    // print('myList : ${myList}');
    chatroom = await DatabaseMethods().getChatList(myList);
    if (chatroom.isEmpty) {
      print("채팅창이 없습니다.");
      isChatroomExits = true;
      return myList;
    } else {
      print("채팅창이 존재합니다.");
      isChatroomExits = false;
      return myList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isChatroomExits
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/wagon.png',
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 20),
                Text(
                  "아직 거래를 시작하지 않았어요.",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "홈 화면",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.amber,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "에서 거래를 시작해주세요.",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 150),
              ],
            ),
          )
        : FutureBuilder<List<dynamic>>(
            future: getAndSetChatrooms(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _skeletonShimmer();
              } else if (snapshot.hasError) {
                return _errorPage();
              } else {
                return ListView.builder(
                  itemCount: chatroom.length,
                  itemBuilder: (BuildContext context, int index) {
                    final key = chatroom.keys.elementAt(index);
                    print("Key: $key");
                    final item = chatroom[key];
                    // print("item: $item");

                    // 상대방 이름 판별
                    myRole = myUserId == item['seller']['sellerId']
                        ? 'seller'
                        : 'buyer';
                    otherRole = myRole == 'seller' ? 'buyer' : 'seller';
                    // 나가기 여부
                    isExit = item[myRole]['isExit'];
                    // 읽음 여부
                    isRead = item[myRole]['unRead'] == 0 ? true : false;
                    lastMessage = item!['list']['lastMessage']!;

                    return Container(
                      margin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChattingDetailPage(chatRoomListInfoMap: {
                                "chatroomId": key,
                                "otherUserName": item![otherRole]['userName']!,
                                "otherUserId": item![otherRole]
                                    ['${otherRole}Id']!,
                                "otherRole": otherRole,
                                "myRole": myRole
                              });
                            },
                          )).then((result) {
                            // 다음 화면에서 반환한 데이터(result)를 처리
                            if (result == "data_changed") {
                              // 데이터가 변경되었을 때 처리
                              getAndSetChatrooms();
                            }
                          });
                        },
                        child: isExit
                            ? Row()
                            : Dismissible(
                                key: Key(key),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    bool? confirmExit = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0), // 원하는 Radius 값으로 설정
                                          ),
                                          title: Text("확인"),
                                          content: Text("채팅방을 나가시겠어요?"),
                                          actions: [
                                            TextButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                        Size>(Size(100, 50)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.grey.shade200),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.black),
                                              ),
                                              child: Text(
                                                "취소",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            TextButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                        Size>(Size(100, 50)),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                              ),
                                              child: Text(
                                                "나가기",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                              onPressed: () {
                                                DatabaseMethods()
                                                    .setExit(key, myRole!);
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    return confirmExit == true;
                                  }
                                  return false;
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 7, 20, 7),
                                  alignment: Alignment.centerRight,
                                  color: Colors.red,
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                                child: Container(
                                    // margin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
                                    width: double.infinity,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Stack(children: [
                                          const Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/profile.jpg'),
                                                radius: 32,
                                              ),
                                              SizedBox(width: 16),
                                            ],
                                          ),
                                          isRead
                                              ? Row()
                                              : Positioned(
                                                  bottom: 3,
                                                  right: 10,
                                                  child: Container(
                                                    width:
                                                        22, // 동그라미의 지름을 원하는 크기로 조정
                                                    height: 22,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFFFFD954),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        item![myRole]['unRead']!
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ]),
                                        Flexible(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        item![otherRole]
                                                            ['userName']!,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 9),
                                                      Text(
                                                        item!['list'][
                                                            'lastMessageSendTs']!,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 11,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    lastMessage.length > 10
                                                        ? '${lastMessage.substring(0, 10)}...'
                                                        : lastMessage,
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 15, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image(
                                                        height: 58,
                                                        width: 58,
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          transactionUrl,
                                                        ))),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                      ),
                    );
                  },
                );
              }
            });
  }

  Widget _errorPage() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(image: AssetImage('assets/images/bad_don.png')),
        Text("사용자 정보를 확인할 수 없습니다.",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
      ]),
    );
  }


  Widget _skeletonShimmer() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
            width: double.infinity,
            height: 90,
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
            child: Row(
              children: [
                const SizedBox(width: 15),
                Stack(children: [
                  Row(
                    children: [
                      Shimmer.fromColors(
                          child: Container(
                            width: 64, // 지름의 2배로 설정
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // 원 모양
                              color: Colors.grey, // 원의 색상 (회색)
                            ),
                            child: Column(),
                          ),
                          baseColor: Color.fromRGBO(240, 240, 240, 1),
                          highlightColor: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ]),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Shimmer.fromColors(
                                  child: Container(
                                    height: 23,
                                    width: 80,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(240, 240, 240, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(),
                                  ),
                                  baseColor: Color.fromRGBO(240, 240, 240, 1),
                                  highlightColor: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                              child: Container(
                                height: 23,
                                width: 150,
                                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(),
                              ),
                              baseColor: Color.fromRGBO(240, 240, 240, 1),
                              highlightColor: Colors.white)
                        ],
                      ),
                      Shimmer.fromColors(
                          child: Container(
                            height: 60,
                            width: 60,
                            margin: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(),
                          ),
                          baseColor: Color.fromRGBO(240, 240, 240, 1),
                          highlightColor: Colors.white),
                    ],
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
