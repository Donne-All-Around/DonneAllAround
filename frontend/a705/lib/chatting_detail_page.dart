import 'package:a705/chatting_page.dart';
import 'package:a705/dto/TransactionInfo.dart';
import 'package:a705/service/database.dart';
import 'package:a705/appointment_page.dart';
import 'package:a705/service/spring_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChattingDetailPage extends StatefulWidget {
  final Map<String, dynamic>? transactionInfoMap;
  final Map<String, dynamic>? chatRoomDetailInfoMap;

  const ChattingDetailPage({
    Key? key,
    this.transactionInfoMap,
    this.chatRoomDetailInfoMap,
  }) : super(key: key);

  @override
  State<ChattingDetailPage> createState() => _ChattingDetailPageState();
}

enum InfoType {
  ChatRoomDetailInfo,
  TransactionInfo,
  None,
}

class _ChattingDetailPageState extends State<ChattingDetailPage> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = false;
  TextEditingController messageController = new TextEditingController();
  String? messageId; // 메시지 아이디
  String myUserName = "", // 내 닉네임
      myUserId = "", // 내 아이디
      myProfilePic = "", // 내 프로필
      chatRoomId = "", // 채팅방 아이디
      otherUserName = "", // 상대방 닉네임
      seller = "", // 판매자 닉네임
      sellerId = "", // 판매자 아이디
      buyer = "", // 구매자 닉네임
      buyerId = "", // 구매자 아이디
      transactionId = "", // 거래글 아이디
      transactionTitle = "", // 거래글 제목
      countryCode = "", // 거래글 통화 국가
      transactionUrl = "", // 거래글 썸네일
      type = "", // 거래 방법
      status = ""; // 거래 상태
  int foreignCurrencyAmount = 0, koreanWonAmount = 0;
  String _appt = "약속 잡기";
  Stream? messageStream;
  int batchSize = 10; // 한 번에 가져올 메시지 수
  bool isLoadingMore = false; // 추가 메시지 로딩 중인지 여부
  DocumentSnapshot? lastVisibleMessage; // 마지막으로 로드된 메시지를 추적하는 데 사용됩니다.
  bool reachedTop = false; // 스크롤이 맨 위에 도달했는지 여부
  bool? isSellerExit, isBuyerExit;

  // 채팅방 정보 가져오기
  getUserInfo() async {
    // 예시 시작
    myUserName = "이병건";
    myUserId = "abcdef";
    // 예시 끝
    setState(() {});
  }

  // 로드
  ontheload() async {
    await getUserInfo(); // 내 정보 가져오기
    // transactionInfoMap이 있거나 chatRoomDetailInfoMap이 있는 경우, 초기화합니다.
    if (widget.transactionInfoMap != null ||
        widget.chatRoomDetailInfoMap != null) {
      await _initializeInfo(
          widget.transactionInfoMap, widget.chatRoomDetailInfoMap);
    }
    await getAndSetMessages(); // 채팅 내역 가져오기
    setState(() {});
  }

  // 초기화
  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Future<void> _initializeInfo(
    Map<String, dynamic>? transactionInfoMap,
    Map<String, dynamic>? chatRoomDetailInfoMap,
  ) async {
    var infoType = InfoType.None;
    if (chatRoomDetailInfoMap != null) {
      infoType = InfoType.ChatRoomDetailInfo;
    } else if (transactionInfoMap != null) {
      infoType = InfoType.TransactionInfo;
    }

    switch (infoType) {
      case InfoType.ChatRoomDetailInfo:
        // ChatRoomDetailInfo를 초기화합니다.
        chatRoomId = widget.chatRoomDetailInfoMap?['chatroomId'] ?? "";
        print("chatRoomId: $chatRoomId");
        List<String> chatRoomInfoList = chatRoomId!.split("_");

        // 채팅 참여자 정보 설정하기
        transactionId = chatRoomInfoList[0];
        sellerId = chatRoomInfoList[1];
        buyerId = chatRoomInfoList[2];
        otherUserId = widget.chatRoomDetailInfoMap?['otherUserId'] ?? "";
        otherUserName = widget.chatRoomDetailInfoMap?['otherUserName'] ?? "";
        otherRole = widget.chatRoomDetailInfoMap?['otherRole'] ?? "";
        myRole = widget.chatRoomDetailInfoMap?['myRole'] ?? "";

        if (otherRole == "seller") {
          seller = otherUserName;
          buyer = myUserName;
        } else if (otherRole == "buyer") {
          seller = myUserName;
          buyer = otherUserName;
        }

        // 거래글 정보 가져오기
        Map<String, dynamic> data =
            await SpringApi().getChatTransactionInfo("12");
        Trade trade = Trade.fromJson(data);
        transactionId = trade.id.toString();
        transactionTitle = trade.title;
        countryCode = trade.countryCode;
        type = trade.type;
        status = trade.status;
        transactionUrl = trade.thumbnailImage;
        koreanWonAmount = trade.koreanWonAmount;
        foreignCurrencyAmount = trade.foreignCurrencyAmount;
        break;

      case InfoType.TransactionInfo:
        // 거래글 정보 가져오기
        // 새로 만들 시, 상대방은 seller 사용자는 buyer
        Map<String, dynamic> data =
            await SpringApi().getChatTransactionInfo("12");
        Trade trade = Trade.fromJson(data);
        transactionId = trade.id.toString();
        transactionTitle = trade.title;
        countryCode = trade.countryCode;
        type = trade.type;
        status = trade.status;
        transactionUrl = trade.thumbnailImage;
        koreanWonAmount = trade.koreanWonAmount;
        foreignCurrencyAmount = trade.foreignCurrencyAmount;
        // transactionId = widget.transactionInfoMap?['transactionId'] ?? "";
        print("transactionId : $transactionId");

        // 채팅 참여자 정보 설정하기
        seller = widget.transactionInfoMap?['seller'];
        sellerId = trade.sellerId.toString();
        buyer = myUserName;
        buyerId = myUserId;
        chatRoomId = "${transactionId!}_${sellerId!}_${buyerId!}";
        otherUserName = seller;

        // user 정보에 새 채팅방 목록 추가
        Map<String, dynamic> chatRoomListInfoMap = {
          "sellerId": sellerId,
          "buyerId": buyerId,
        };
        print("user에 chatlist update: ${transactionId}");
        DatabaseMethods().setUserChatList(
            sellerId!, buyerId!, chatRoomId!, chatRoomListInfoMap);
        break;

      case InfoType.None:
        // 아무 작업도 수행하지 않습니다.
        break;
    }
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
                      } else if (snapshot.data.docs[index + 1]["ts"] !=
                          currentTs) {
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
                    } else {
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

      // user 정보 업데이트
      /**
       * 현재 접속한 user 비교 후, 상대방의 unread 갱신
       */

      String otherRole =
          otherUserName == seller ? "seller" : "buyer"; // 상대방 collection 찾기

      Map<String, dynamic> sellerInfoMap = {
        "sellerId": sellerId, // 판매자 아이디
        "userName": seller, // 판매자 닉네임
        "isExit": false, // 나가기를 했었다면, 강제 초대
        "unRead": FieldValue.increment(1), // 안 읽음 수 증가
      };

      Map<String, dynamic> buyerInfoMap = {
        "buyerId": buyerId, // 구매자 아이디
        "userName": buyer, // 구매자 닉네임
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
          .addMessageUser(chatRoomId!, messageId!, messageInfoMap, otherRole!,
              myRole!, sellerInfoMap, buyerInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName,
          "transactionId": transactionId,
          "transactionUrl": "",
        };

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
    String myRole = myUserName == seller ? "seller" : "buyer";
    DatabaseMethods().setRead(chatRoomId, myRole); // 읽음 처리
    setState(() {});
  }

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
                Navigator.pop(context, "data_changed");
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
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "",
                                  transactionTitle,
                                  style: const TextStyle(
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
                                      "${NumberFormat.decimalPattern().format(foreignCurrencyAmount)} ${countryCode}",
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
                                      "${NumberFormat.decimalPattern().format(koreanWonAmount)}원",
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
                        String appt = await Navigator.push(
                            context,
                            MaterialPageRoute(
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
                          controller: messageController,
                          // 메시지 전송 컨트롤러
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
