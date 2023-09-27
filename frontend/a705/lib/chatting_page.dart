import 'package:a705/dto/TransactionInfo.dart';
import 'package:a705/service/database.dart';
import 'package:a705/service/spring_api.dart';
import 'package:flutter/material.dart';

import 'package:a705/chatting_detail_page.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  Map<String, Map<String, String>> items = {};
  Map<String, dynamic> chatroom = {};
  dynamic? lastMessage = "", ts = "";

  // 로드
  ontheload() async {

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
          const Expanded(child: ListViewBuilder()),
          // Expanded(
          //   child: StreamBuilder(
          //     stream: chatroomStream,
          //     builder: (context, AsyncSnapshot snapshot) {
          //       if (!snapshot.hasData) {
          //         return CircularProgressIndicator(); // 데이터를 기다리는 동안 로딩 표시
          //       }
          //
          //       return ListView.builder(
          //         itemCount: snapshot.data.docs.length,
          //         itemBuilder: (context, index) {
          //           DocumentSnapshot ds = snapshot.data.docs[index];
          //           // chatroom에서 필요한 데이터를 추출하고 표시하는 로직을 추가하세요.
          //           // 예를 들어, chatroom["user"]["1"] 및 chatroom["user"]["2"]를 가져올 수 있습니다.
          //           // 필요에 따라서 chatroom 데이터를 가공하여 표시하세요.
          //           QueryDocumentSnapshot docSnapshot =
          //               snapshot.data.docs[index];
          //
          //           Map<String, dynamic> data =
          //               docSnapshot.data() as Map<String, dynamic>;
          //           ts = data['lastMessageSendTs']; // 필드 이름으로 변경
          //           lastMessage = data['lastMessage'];
          //
          //           print("문서 ID: ${docSnapshot.id}, 필드 값: $ts");
          //
          //           Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot = docSnapshot.reference.collection('userRole').get();
          //
          //           querySnapshot.then((querySnapshot) {
          //             for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
          //               Map<String, dynamic> data = documentSnapshot.data();
          //               String? fieldName = data['userName'];
          //               // Process data as needed
          //               print(fieldName);
          //
          //
          //               if(data['userName'] != myUserName){ // 상대방
          //                 otherUserName = data['userName'];
          //                 otherImgUrl = data[''];
          //               }else{ // 사용자
          //                 unRead = data['unRead'];
          //                 isExit = data['isExit'];
          //               }
          //
          //
          //             }
          //           }).catchError((error) {
          //             // Handle any errors
          //           });
          //
          //
          //           // print(a);
          //           // 프로필 이미지
          //           // 게시글 이미지
          //           // 상대방 이름
          //           // "user" 하위 컬렉션의 참조 얻기
          //           // CollectionReference usersCollection = chatroom.reference.collection('user');
          //           //
          //           // // "user" 하위 컬렉션에서 데이터 가져오기 (예: 모든 문서 가져오기)
          //           // usersCollection.get().then((querySnapshot) {
          //           //   querySnapshot.docs.forEach((doc) {
          //           //     // 각 문서의 데이터에 접근
          //           //     var userData = doc.data(); // 문서 데이터(Map) 가져오기
          //           //     print(userData); // 데이터 출력 또는 처리
          //           //   });
          //           // }).catchError((error) {
          //           //   print("Error getting users: $error");
          //           // });
          //
          //           // 라스트 메시지
          //           // 라스트 메시지 시간
          //           // 안읽음 개수
          //           return GestureDetector(
          //               onTap: () {
          //                 Navigator.push(context, MaterialPageRoute(
          //                   builder: (context) {
          //                     return const ChattingDetailPage();
          //                   },
          //                 ));
          //               },
          //               child: Container(
          //                   margin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
          //                   width: double.infinity,
          //                   height: 90,
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(15),
          //                       color: Colors.white,
          //                       boxShadow: [
          //                         BoxShadow(
          //                           color: Colors.black.withOpacity(0.1),
          //                           spreadRadius: 1,
          //                           blurRadius: 3,
          //                           offset: const Offset(0, 0),
          //                         ),
          //                       ]),
          //                   child: Row(
          //                     children: [
          //                       const SizedBox(width: 15),
          //                       Stack(children: [
          //                         const Row(
          //                           children: [
          //                             CircleAvatar(
          //                               backgroundImage: AssetImage(
          //                                   'assets/images/profile.jpg'),
          //                               radius: 32,
          //                             ),
          //                             SizedBox(width: 16),
          //                           ],
          //                         ),
          //                         Positioned(
          //                           bottom: 3,
          //                           right: 10,
          //                           child: Container(
          //                             width: 22, // 동그라미의 지름을 원하는 크기로 조정
          //                             height: 22,
          //                             decoration: const BoxDecoration(
          //                               shape: BoxShape.circle,
          //                               color: Color(0xFFFFD954),
          //                             ),
          //                             child: const Center(
          //                               child: Text(
          //                                 '5',
          //                                 style: TextStyle(
          //                                   fontSize: 11,
          //                                   color: Colors.black87,
          //                                   fontWeight: FontWeight.bold,
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ]),
          //                       Flexible(
          //                         flex: 1,
          //                         child: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Column(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.center,
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Row(
          //                                   children: [
          //                                     Text(
          //                                       otherUserName!,
          //                                       style: TextStyle(
          //                                         fontSize: 18,
          //                                         fontWeight: FontWeight.bold,
          //                                       ),
          //                                     ),
          //                                     SizedBox(width: 9),
          //                                     Text(
          //                                       ts,
          //                                       style: TextStyle(
          //                                         color: Colors.grey,
          //                                         fontSize: 11,
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                                 SizedBox(height: 5),
          //                                 Text(lastMessage,
          //                                     style: TextStyle(fontSize: 17)),
          //                               ],
          //                             ),
          //                             Container(
          //                               margin: const EdgeInsets.fromLTRB(
          //                                   10, 10, 15, 10),
          //                               decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(15),
          //                                 border:
          //                                     Border.all(color: Colors.grey),
          //                               ),
          //                               child: ClipRRect(
          //                                   borderRadius:
          //                                       BorderRadius.circular(15),
          //                                   child: const Image(
          //                                       height: 58,
          //                                       width: 58,
          //                                       fit: BoxFit.cover,
          //                                       image: AssetImage(
          //                                         'assets/images/ausdollar.jpg',
          //                                       ))),
          //                             )
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   )));
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    ));
  }
}

// final Map<String, Map<String, String>> items = {
//   'item1': {
//     'name': 'Item 1',
//     'description': 'Item 1 Description',
//   },
//   'item2': {
//     'name': 'Item 2',
//     'description': 'Item 2 Description',
//   },
//   'item3': {
//     'name': 'Item 3',
//     'description': 'Item 3 Description',
//   },
//   'item4': {
//     'name': 'Item 4',
//     'description': 'Item 4 Description',
//   },
//   'item5': {
//     'name': 'Item 5',
//     'description': 'Item 5 Description',
//   }};

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
    /**
     * 채팅방 정보 추후에 받아오기
     */
    // 예시 시작
    chatRoomId = "board1_쏘영이_이병건";
    myUserName = "이병건";
    myUserId = "abcdef";
    otherUserName = "쏘영이";
    otherUserId = "123456";
    seller = "쏘영이";
    myPhone = "010-1111-1111";
    transactionId = "board1";
    transactionUrl = 'assets/images/ausdollar.jpg';

    // 예시 끝
    setState(() {});
  }

  // getAndSetChatrooms() 메서드는 이 클래스 내에서 정의합니다.
  getAndSetChatrooms() async {
    print('myUserId : ${myUserId}');
    List<String> myList = await DatabaseMethods().getUserChatList(myUserId!);
    // print('myList : ${myList}');
    chatroom = await DatabaseMethods().getChatList(myList);

    setState(() {}); // 데이터를 가져온 후 화면을 업데이트합니다.
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatroom.length,
      itemBuilder: (BuildContext context, int index) {
        final key = chatroom.keys.elementAt(index);
        print("Key: $key");
        final item = chatroom[key];
        // print("item: $item");

        // 상대방 이름 판별
        myRole = myUserName == item['seller']['userName'] ? 'seller' : 'buyer';
        otherRole = myRole == 'seller' ? 'buyer' : 'seller';
        // 나가기 여부
        isExit = item[myRole]['isExit'];
        // 읽음 여부
        isRead = item['seller']['unRead'] == 0 ? true : false;
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
                  return ChattingDetailPage(chatRoomDetailInfoMap: {
                    "chatroomId": key,
                    "otherUserName": item![otherRole]['userName']!,
                    "otherUserId": item![otherRole]['${otherRole}Id']!,
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
                      if (direction == DismissDirection.endToStart) {
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
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // 원하는 Radius 값으로 설정
                                      ),
                                    ),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(100, 50)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.grey.shade200),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black), // 텍스트 색상을 흰색으로 설정
                                  ),
                                  child: Text(
                                    "취소",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // "취소"를 선택한 경우 false 반환
                                  },
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // 원하는 Radius 값으로 설정
                                      ),
                                    ),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(100, 50)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red), // 배경색을 빨간색으로 설정
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white), // 텍스트 색상을 흰색으로 설정
                                  ),
                                  child: Text(
                                    "나가기",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    // "나가기"를 선택한 경우 true 반환
                                    // 아이템을 삭제하는 로직을 추가
                                    // 여기에서 아이템을 삭제하는 대신, 삭제할 아이템을 표시하지 않도록 설정하거나 데이터에서 제거할 수 있습니다.
                                    // 예: items.removeAt(index); 또는 items[index].isDeleted = true;
                                    DatabaseMethods().setExit(key, myRole!);
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
                      margin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
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
                              isRead
                                  ? Row()
                                  : Positioned(
                                      bottom: 3,
                                      right: 10,
                                      child: Container(
                                        width: 22, // 동그라미의 지름을 원하는 크기로 조정
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFFFD954),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item![otherRole]['unRead']!
                                                .toString(),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item![otherRole]['userName']!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 9),
                                          Text(
                                            item!['list']['lastMessageSendTs']!,
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
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 10, 15, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
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
}
