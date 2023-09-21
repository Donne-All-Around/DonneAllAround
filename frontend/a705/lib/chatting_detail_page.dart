import 'package:a705/service/database.dart';
import 'package:a705/appointment_page.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChattingDetailPage extends StatefulWidget {
  const ChattingDetailPage({super.key});

  @override
  State<ChattingDetailPage> createState() => _ChattingDetailPageState();
}

class _ChattingDetailPageState extends State<ChattingDetailPage> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = false;
  TextEditingController messageController = new TextEditingController();

  // String? myProfilePic, messageId;
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
  int batchSize = 10; // 한 번에 가져올 메시지 수
  bool isLoadingMore = false; // 추가 메시지 로딩 중인지 여부
  DocumentSnapshot? lastVisibleMessage; // 마지막으로 로드된 메시지를 추적하는 데 사용됩니다.
  bool reachedTop = false; // 스크롤이 맨 위에 도달했는지 여부


  // 채팅방 정보 가져오기
  getthesharedpref() async {
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
    DatabaseMethods().setRead(chatRoomId,userId); // 읽음 처리
    // 예시 끝
    setState(() {});
  }

  // 로드
  ontheload() async {
    await getthesharedpref();
    await getAndSetMessages();
    // await getAndSetMessages(); // 이 부분을 추가하여 메시지를 초기에 가져옵니다.
    setState(() {});
  }

  // 초기화
  @override
  void initState() {
    super.initState();
    ontheload();
  }

  void _loadMoreMessages() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      Query query = FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("chats")
          .orderBy("time", descending: true)
          .startAfterDocument(lastVisibleMessage!)
          .limit(batchSize);

      QuerySnapshot additionalMessages = await query.get();

      if (additionalMessages.docs.isNotEmpty) {
        lastVisibleMessage =
            additionalMessages.docs[additionalMessages.docs.length - 1];
        // 기존의 messageStream을 업데이트합니다.
        messageStream = FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(chatRoomId)
            .collection("chats")
            .orderBy("time", descending: true)
            .startAfterDocument(lastVisibleMessage!)
            .limit(batchSize)
            .snapshots();
      }

      setState(() {
        isLoadingMore = false;
      });
    }
  }

// 채팅 메시지 가져오기
  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true) // 시간 역순으로 스트림 반환
        .snapshots();
  }

  // 채팅 메시지 타일
  Widget chatMessageTile(
      String message, bool sendByMe, String ts, bool showTs, bool showProfile) {
    return Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          sendByMe
              ? Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: showTs
                      ? Text(
                    ts,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  )
                      : Text(""),
                )
              : Row(
                  children: [
                    showProfile
                        ? const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profile.jpg'),
                              radius: 25,
                            ),
                          )
                        : const Padding(padding: EdgeInsets.only(left: 66.0)),
                    const SizedBox(height: 10)
                  ],
                ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft:
                          sendByMe ? Radius.circular(18) : Radius.circular(0),
                      bottomRight: Radius.circular(18),
                      topRight:
                          sendByMe ? Radius.circular(0) : Radius.circular(18),
                      bottomLeft: Radius.circular(18)),
                  color: sendByMe
                      ? const Color(0xFFFFE897)
                      : Colors.grey.shade200),
              // : Colors.grey.shade200),
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
                maxLines: 6, // 텍스트 줄 수 제한 없음
                softWrap: true, // 자동 줄 바꿈 활성화
                overflow: TextOverflow.clip, // 잘린 부분은 보이도록 함
              ),
            ),
          ),
          sendByMe
              ? const Text("")
              : Container(
                  margin: EdgeInsets.only(right: 16.0), // 왼쪽 마진 설정
                  child: showTs
                      ? Text(
                          ts,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        )
                      : Text(""),
                )
        ]);
  }

  // 채팅 메시지
  Widget chatMessage() {
    return NotificationListener<ScrollUpdateNotification>(
      // onNotification: (ScrollUpdateNotification scrollInfo) {
      //   value.listner(scrollInfo);
      //   // if (!isLoadingMore &&
      //   //     scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
      //   //     !reachedTop) {
      //   //   // 스크롤이 맨 아래에 도달하면 추가 메시지를 가져오도록 하고,
      //   //   // 스크롤이 맨 위에 도달하지 않았을 때만 호출합니다.
      //   //   loadMoreMessages();
      //   //   return true;
      //   // } else if (scrollInfo.metrics.pixels ==
      //   //     scrollInfo.metrics.minScrollExtent) {
      //   //   // 스크롤이 맨 위로 도달하면 더 이상 메시지를 로드하지 않음을 표시합니다.
      //   //   setState(() {
      //   //     reachedTop = true;
      //   //   });
      //   // }else if (reachedTop && !isLoadingMore) {
      //   //   // 스크롤이 맨 위에 도달한 후 다시 스크롤을 아래로 내릴 때 추가 메시지를 불러오도록 합니다.
      //   //   loadMoreMessages();
      //   // }
      //   return false;
      // },
      child: StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _scrollController,
                  // 스크롤 컨트롤러 설정
                  padding: EdgeInsets.only(bottom: 90.0, top: 130),
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  // 화면이 맨 아래로 스크롤되도록 설정
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    // 프로필 이미지 출력 여부
                    String? currentUserName = ds["sendBy"];
                    String? currentTs = ds["ts"];

                    bool showProfile = false;
                    bool showTs = false;

                    if (snapshot.data.docs.length != index + 1) {
                      if (snapshot.data.docs[index + 1]["sendBy"] !=
                          currentUserName) {
                        showProfile = true;
                      }else if(snapshot.data.docs[index+1]["ts"] != currentTs){
                        showProfile = true;
                      }
                    } else {
                      showProfile = myUserName != currentUserName;
                    }
                    // 시간 비교 출력 여부
                    if (index > 0) {
                      if (snapshot.data.docs[index - 1]["sendBy"] ==
                          currentUserName) {
                        // 시간이 다르면 출력
                        if (snapshot.data.docs[index - 1]["ts"] != currentTs) {
                          showTs = true;

                        } // 같으면 출력 안 함
                      } else {
                        showTs = true;
                      }
                    }else{
                      showTs = true;
                    }
                    return chatMessageTile(
                      ds["message"],
                      myUserName == currentUserName,
                      ds["ts"],
                      showTs,
                      showProfile,
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

// 더 이전 메시지 가져오기
  void loadMoreMessages() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      Query query = FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .collection("chats")
          .orderBy("time", descending: true)
          .limit(batchSize);

      if (lastVisibleMessage != null) {
        query = query.startAfterDocument(lastVisibleMessage!);
      }

      QuerySnapshot? additionalMessages = await query.get();

      if (additionalMessages.docs.isNotEmpty) {
        lastVisibleMessage =
            additionalMessages.docs[additionalMessages.docs.length - 1];
        messageStream = FirebaseFirestore.instance
            .collection("chatRooms")
            .doc(chatRoomId)
            .collection("chats")
            .orderBy("time", descending: true)
            .startAfterDocument(lastVisibleMessage!)
            .limit(batchSize)
            .snapshots();
      }

      setState(() {
        isLoadingMore = false;
      });
    }
  }

  // 메시지 추가
  addMessage(bool sendClicked) {
    if (messageController.text != "") {
      String message = messageController.text;
      messageController.text = "";

      DateTime now = DateTime.now();
      String formattedDate =
          DateFormat('h:mma').format(now.add(Duration(hours: 9))); // UTC + 9
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate, // timestamp
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic,
      };

      // 상대방 정보 업데이트
      String userId = otherUserName == seller ? "1" : "2"; // seller면 1 buyer면 2
      Map<String, dynamic> userInfoMap = {
        "userName": otherUserName, // 상대방
        "isExit": false, // 나가기를 했었다면, 강제 초대
        "unRead": FieldValue.increment(1), // 안 읽음 수 증가
      };

      /**
       * 메시지 ID가 null이면 랜덤 10 ID 부여
       * if(messageId == null){messageId = randomAlphaNumeric(10);}
       */
      messageId ??= randomAlphaNumeric(10);
      // 마지막 메시지
      DatabaseMethods()
          .addMessageUser(
              chatRoomId!, messageId!, messageInfoMap, userId!, userInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName,
          "transactionId" : transactionId,
        };
        print(lastMessageInfoMap);
        DatabaseMethods()
            .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if (sendClicked) {
          messageId = null;
        }
      });
      // 메시지를 보낸 후 화면을 맨 아래로 스크롤
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // 메시지 작성 읽기
  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }
  String _appt = "약속 잡기";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isVisible = false;
        });
      },
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
            title: Text(
              otherUserName ?? "알수없음",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
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
                          margin: const EdgeInsets.fromLTRB(20, 15, 10, 10),
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
                                      backgroundImage: AssetImage(
                                          'assets/images/AUD.png'),
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
                    GestureDetector(
                      onTap: () async {
                        String appt = await Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AppointmentPage()));
                        setState(() {
                          _appt = appt;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        height: 35,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0xFFFFD954),
                        ),
                        child: Center(
                            child: Text(
                          _appt,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: chatMessage(),
              ),
              // const Expanded(
              //   child: ListViewBuilder(),
              // ),
              Container(
                color: const Color(0xFFFFD954),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          isVisible = !isVisible;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: TextField(
                          controller: messageController, // 메시지 전송 컨트롤러
                          onTap: () {
                            setState(() {
                              isVisible = false;
                            });
                          },
                          cursorColor: Colors.black38,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
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
                    IconButton(
                      onPressed: () {
                        addMessage(true);
                      },
                      icon: Icon(Icons.send),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = true;
                  });
                },
                child: Visibility(
                  visible: isVisible,
                  // visible: true,
                  child: Container(
                    color: const Color(0xFFFFFDF8),
                    width: double.infinity,
                    height: 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD954),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.photo_outlined),
                            ),
                            const SizedBox(height: 5),
                            const Text('사진'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD954),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.edit_calendar_outlined),
                            ),
                            const SizedBox(height: 5),
                            const Text('약속'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD954),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                  Icons.account_balance_wallet_outlined),
                            ),
                            const SizedBox(height: 5),
                            const Text('송금'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD954),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 5),
                            const Text('배송정보'),
                          ],
                        ),
                      ],
                    ),
                  ),
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
        return index > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                                  const SizedBox(width: 10),
                                  const Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/profile.jpg'),
                                        radius: 25,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(
                                            '옹골찬',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      BubbleSpecialOne(
                                        text: chatList[index],
                                        isSender: false,
                                        color: Colors.grey.shade200,
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const Text('오후 2:10',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ))
                                ],
                              ))
                        ],
                      ))
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('오후 2:20',
                            style: TextStyle(
                              fontSize: 10,
                            )),
                        BubbleSpecialOne(
                          text: chatList[index],
                          isSender: true,
                          color: const Color(0xFFFFE897),
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
      },
    );
  }
}

List<String> chatList = [
  "제가 감기에 걸려가..",
  "죄송한데 3시 30분도 가능하실까요",
  "3시까지 나갈게요~",
  "네 알겠습니다!",
  "도착하시면 연락 부탁드려요.",
  "흰 티에 청바지 입고있어요",
  "역삼역 1번출구 앞에서 직거래 희망합니다",
  "3시에 거래 가능할까요",
];
