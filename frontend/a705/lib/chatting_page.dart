import 'package:a705/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:a705/chatting_detail_page.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  // 내 정보
  String? myUserName, // 내 닉네임
      myProfilePic, // 내 프로필
      myPhone, // 내 번호
      messageId, // 메시지 아이디
      chatRoomId, // 채팅방 아이디
      otherUserName, // 상대방 닉네임
      seller, // 판매자 닉네임
      buyer, // 구매자 닉네임
      transactionId; // 거래글 아이디

  Stream? messageStream;

  // 채팅방 정보 가져오기
  getUserInfo() async {
    /**
     * 채팅방 정보 추후에 받아오기
     */
    // myUserName = await SharedPreferenceHelper().getUserName();
    // myProfilePic = await SharedPreferenceHelper().getUserPic();
    // myPhone = await SharedPreferenceHelper().getUserPhone();

    // 예시 시작
    chatRoomId = "board1_쏘영이_이병건";
    myUserName = "쏘영이";
    otherUserName = "이병건";
    seller = "쏘영이";
    myPhone = "010-1111-1111";
    transactionId = "board1";
    String userId = myUserName == seller ? "1" : "2";
    DatabaseMethods().setRead(chatRoomId, userId); // 읽음 처리
    // 예시 끝
    setState(() {});
  }

  // 로드
  ontheload() async {
    await getUserInfo();
    await getAndSetChatrooms();
    // await getAndSetMessages(); // 이 부분을 추가하여 메시지를 초기에 가져옵니다.
    setState(() {});
  }

  // 메시지 작성 읽기
  getAndSetChatrooms() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  // 초기화
  @override
  void initState() {
    super.initState();
    ontheload();
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
          // const Expanded(child: ListViewBuilder()),
          Expanded(
            child: StreamBuilder(
              stream: messageStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(); // 데이터를 기다리는 동안 로딩 표시
                }

                List<DocumentSnapshot> chatrooms = snapshot.data.docs;

                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot chatroom = chatrooms[index];
                    // chatroom에서 필요한 데이터를 추출하고 표시하는 로직을 추가하세요.
                    // 예를 들어, chatroom["user"]["1"] 및 chatroom["user"]["2"]를 가져올 수 있습니다.
                    // 필요에 따라서 chatroom 데이터를 가공하여 표시하세요.



                    // 프로필 이미지
                    // 게시글 이미지
                    // 상대방 이름
                    // "user" 하위 컬렉션의 참조 얻기
                    CollectionReference usersCollection = chatroom.reference.collection('user');

                    // "user" 하위 컬렉션에서 데이터 가져오기 (예: 모든 문서 가져오기)
                    usersCollection.get().then((querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        // 각 문서의 데이터에 접근
                        var userData = doc.data(); // 문서 데이터(Map) 가져오기
                        print(userData); // 데이터 출력 또는 처리
                      });
                    }).catchError((error) {
                      print("Error getting users: $error");
                    });

                    // 라스트 메시지
                    // 라스트 메시지 시간
                    // 안읽음 개수
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const ChattingDetailPage();
                            },
                          ));
                        },
                        child: Container(
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
                                  Positioned(
                                    bottom: 3,
                                    right: 10,
                                    child: Container(
                                      width: 22, // 동그라미의 지름을 원하는 크기로 조정
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFFD954),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '5',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
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
                                                "1",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 9),
                                              Text(
                                                "2",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text("3",
                                              style: TextStyle(fontSize: 17)),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 10, 15, 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: const Image(
                                                height: 58,
                                                width: 58,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  'assets/images/ausdollar.jpg',
                                                ))),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )));
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

List<String> chatroom = ['옹골찬', '김싸피', '박싸피', '정현아', '문요환', '별의 커비', '뽀로로'];

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatroom.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ChattingDetailPage();
              },
            ));
          },
          child: Container(
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
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                          radius: 32,
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                    Positioned(
                      bottom: 3,
                      right: 10,
                      child: Container(
                        width: 22, // 동그라미의 지름을 원하는 크기로 조정
                        height: 22,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD954),
                        ),
                        child: const Center(
                          child: Text(
                            '5',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                                Text(
                                  chatroom[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                const Text(
                                  '1시간 전',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text('좋은 밤 되세요',
                                style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: const Image(
                                  height: 58,
                                  width: 58,
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/ausdollar.jpg',
                                  ))),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
