import 'package:a705/service/database.dart';
import 'package:a705/service/shared_pref.dart';
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
  bool isVisible = false;
  TextEditingController messageController = new TextEditingController();
  // String? myProfilePic, messageId;
  String? myUserName, myProfilePic, myPhone, messageId, chatRoomId;
  Stream? messageStream;





  // 채팅방 정보 가져오기
  getthesharedpref() async {
    /**
     * 채팅방 정보 추후에 받아오기
     */
    // myUserName = await SharedPreferenceHelper().getUserName();
    // myProfilePic = await SharedPreferenceHelper().getUserPic();
    // myPhone = await SharedPreferenceHelper().getUserPhone();
    // 예시 시작
    chatRoomId = "1";
    myUserName = "이병건";
    myPhone = "010-1111-1111";
    // 예시 끝
    setState(() {});
  }

  // 로드
  ontheload() async {
    await getthesharedpref();
    await getAndSetMessages(); // 이 부분을 추가하여 메시지를 초기에 가져옵니다.
    setState(() {});
  }

  // 초기화
  @override
  void initState() {
    super.initState();
    ontheload();
  }

  // 채팅 메시지 타일
  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
      sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0)),
                  color: sendByMe
                      ? Color.fromARGB(255, 234, 236, 240)
                      : Color.fromARGB(255, 211, 228, 243)),
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
            )),
      ],
    );
  }
  // 채팅 메시지
  Widget chatMessage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              padding: EdgeInsets.only(bottom: 90.0, top: 130),
              itemCount: snapshot.data.docs.length,
              reverse: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return chatMessageTile(
                    ds["message"], myUserName == ds["sendBy"]);
              })
              : Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  // 메시지 추가
  addMessage(bool sendClicked){
    if(messageController.text != ""){
      String message = messageController.text;
      messageController.text = "";

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(now);
      Map<String, dynamic> messageInfoMap = {
        "message" : message,
        "sendBy" : myUserName,
        "ts" : formattedDate, // timestamp
        "time" : FieldValue.serverTimestamp(),
        "imgUrl" : myProfilePic,
      };
      // if(messageId == null){
      //   messageId = randomAlphaNumeric(10);
      // }
      /**
       * 메시지 ID가 null이면 랜덤 10 ID 부여
       */
      messageId ??= randomAlphaNumeric(10);
      // 마지막 메시지
      DatabaseMethods().addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage" : message,
          "lastMessageSendTs" : formattedDate,
          "time" : FieldValue.serverTimestamp(),
          "lastMessageSendBy" : myUserName,
        };
        print(lastMessageInfoMap);
        DatabaseMethods().updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if(sendClicked){
          messageId = null;
        }
      });
    }
  }

  // 메시지 작성 읽기
  getAndSetMessages() async {
    chatRoomId = "1";
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
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
                                          'assets/images/australia.png'),
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
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      height: 35,
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
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const Text('오후 2: 10',
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
                        const Text('오후 2: 20',
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
