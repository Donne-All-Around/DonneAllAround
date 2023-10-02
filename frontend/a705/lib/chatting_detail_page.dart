import 'package:a705/chatting_page.dart';
import 'package:a705/models/TradeAppointmentDto.dart';
import 'package:a705/service/database.dart';
import 'package:a705/appointment_page.dart';
import 'package:a705/service/spring_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:a705/transaction_info_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChattingDetailPage extends StatefulWidget {
  final Map<String, dynamic>? tradeInfoMap;
  final Map<String, dynamic>? chatRoomListInfoMap;

  const ChattingDetailPage({
    Key? key,
    this.tradeInfoMap,
    this.chatRoomListInfoMap,
  }) : super(key: key);

  @override
  State<ChattingDetailPage> createState() => _ChattingDetailPageState();
}

enum InfoType {
  CHATROOMLIST,
  TRADE,
  NONE,
}

enum AppointmentType {
  waitBuyer, // 예약 전, 구매자
  waitSeller, // 예약 전, 판매자
  progressBuyerDirect, // 예약 중, 구매자, 직거래
  progressSellerDirect, // 예약 중, 판매자, 직거래
  progressBuyerDeliveryBefore, // 예약 중, 구매자, 택배 거래, 송장 번호 입력 전
  progressBuyerDeliveryAfter, // 예약 중, 구매자, 택배 거래, 송장 번호 입력 후
  progressSellerDeliveryBefore, // 예약 중, 판매자, 택배 거래, 송장 번호 입력 전
  progressSellerDeliveryAfter, // 예약 중, 판매자, 택배 거래, 송장 번호 입력 후
  progressOther, // 예약 중, 타 사용자
  completeSeller, // 거래 완료, 판매자
  completeBuyer, // 거래 완료, 구매자
  completeOther, // 거래 완료, 타 사용자
}

class _ChattingDetailPageState extends State<ChattingDetailPage> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = false;
  TextEditingController messageController = new TextEditingController();
  String? messageId, // 메시지 아이디
      myUserName, // 내 닉네임
      myUserId, // 내 아이디
      myRole, // 내 역할
      chatRoomId, // 채팅방 아이디
      otherUserName, // 상대방 닉네임
      otherUserId, // 상대방 아이디
      otherRole, // 상대방 역할
      seller, // 판매자 닉네임
      sellerId, // 판매자 아이디
      buyer, // 구매자 닉네임
      buyerId, // 구매자 아이디
      tradeId, // 거래글 아이디
      tradeTitle, // 거래글 제목
      countryCode, // 거래글 통화 국가
      thumbnailImageUrl, // 거래글 썸네일
      type, // 거래 방법
      status, // 거래 상태
      directTradeTime, // 직거래 약속 시간
      directTradeLocationDetail, // 직거래 상제 장소
      sellerAccountBankCode, // 판매자 은행 코드
      sellerAccountNumber, // 판매자 은행 계좌번호
      deliveryRecipientName, // 택배거래 구매자 이름
      deliveryRecipientTel, // 택배거래 구매자 번호
      deliveryAddressZipCode, // 택버거래 주소 우편번호
      deliveryAddress, // 택배거래 주소
      deliveryAddressDetail, // 택배거래 상세 주소
      trackingNumber; // 송장번호
  int foreignCurrencyAmount = 0, koreanWonAmount = 0;
  String? _appt;
  Stream? messageStream, apptStream;
  bool? isSellerExit, isBuyerExit;
  bool isBlank = false;
  AppointmentType appointmentType = AppointmentType.waitBuyer;



  // 채팅방 정보 가져오기
  getUserInfo() async {
    myUserName = "신짱구";
    myUserId = "3";
    setState(() {});
  }

  // 거래 약속 상태
  setTradeAppointment() async {
    switch (status) {
      case "WAIT":
        // 구매(희망)자
        if (myRole == "buyer") {
          appointmentType = AppointmentType.waitBuyer;
        }
        // 판매자
        else if (myRole == "seller") {
          appointmentType = AppointmentType.waitSeller;
          _appt = "약속 잡기";
        }
        break;
      case "PROGRESS":
        // 구매자
        if (myRole == "buyer") {
          // 직거래
          if (type == "DIRECT") {
            appointmentType = AppointmentType.progressBuyerDirect;
            _appt = "${directTradeLocationDetail} ${directTradeTime}";
          }
          // 택배거래
          else if (type == "DELIVERY") {
            if (trackingNumber == null) {
              // 송장번호 입력 전
              appointmentType = AppointmentType.progressBuyerDeliveryBefore;
              _appt = "아직 배송 전이에요.";
            } else {
              // 송장번호 입력 후
              appointmentType = AppointmentType.progressBuyerDeliveryAfter;
              _appt = "수령확인";
            }
          }
        }
        // 판매자
        else if (myRole == "seller") {
          // 직거래
          if (type == "DIRECT") {
            appointmentType = AppointmentType.progressSellerDirect;
            _appt = "${directTradeLocationDetail} ${directTradeTime}";
          }
          // 택배거래
          else if (type == "DELIVERY") {
            if (trackingNumber == null) {
              // 송장번호 입력 전
              appointmentType = AppointmentType.progressSellerDeliveryBefore;
              _appt = "송장번호 입력";
            } else {
              // 송장번호 입력 후
              appointmentType = AppointmentType.progressSellerDeliveryAfter;
              _appt = "$trackingNumber";
            }
          }
        }
        // 타 사용자
        else {
          appointmentType = AppointmentType.progressOther;
          _appt = "거래 중";
        }
        break;
      case "COMPLETE":
        // 구매자
        if (myRole == "buyer") {
          appointmentType = AppointmentType.completeBuyer;
        }
        // 판매자
        else if (myRole == "seller") {
          appointmentType = AppointmentType.completeSeller;
        }
        // 타 사용자
        else {
          appointmentType = AppointmentType.completeOther;
        }
        _appt = "거래완료";
        break;
    }

    print('사용자 약속 Type: $appointmentType');
    setState(() {});
  }

  // 로드
  ontheload() async {
    await getUserInfo(); // 내 정보 가져오기
    if (widget.tradeInfoMap != null || widget.chatRoomListInfoMap != null) {
      await _initializeInfo(
          widget.tradeInfoMap, widget.chatRoomListInfoMap); // 거래글 가져오기
    }
    print("I'm $myRole");
    await setTradeAppointment(); // 거래 약속 set
    await getAndSetMessages(); // 채팅 내역 가져오기
    setState(() {});
  }

  // 초기화
  @override
  void initState() {
    super.initState();
    ontheload();
  }

  bool _shouldShowGestureDetector(AppointmentType appointmentType) {
    if (appointmentType == AppointmentType.waitBuyer) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _initializeInfo(
    Map<String, dynamic>? tradeInfoMap,
    Map<String, dynamic>? chatRoomListInfoMap,
  ) async {
    var infoType = InfoType.NONE;
    if (chatRoomListInfoMap != null) {
      infoType = InfoType.CHATROOMLIST;
    } else if (tradeInfoMap != null) {
      infoType = InfoType.TRADE;
    }

    switch (infoType) {
      /**
     * 채팅목록 -> 채팅방
     */
      case InfoType.CHATROOMLIST:
        chatRoomId = widget.chatRoomListInfoMap?['chatroomId'] ?? "";
        print("chatRoomId: $chatRoomId");
        List<String> chatRoomInfoList = chatRoomId!.split("_");

        // 채팅 참여자 정보 설정하기
        tradeId = chatRoomInfoList[0];
        sellerId = chatRoomInfoList[1];
        buyerId = chatRoomInfoList[2];
        otherUserId = widget.chatRoomListInfoMap?['otherUserId'] ?? "";
        otherUserName = widget.chatRoomListInfoMap?['otherUserName'] ?? "";
        otherRole = widget.chatRoomListInfoMap?['otherRole'] ?? "";
        myRole = widget.chatRoomListInfoMap?['myRole'] ?? "";


        if (otherRole == "seller") {
          seller = otherUserName;
          buyer = myUserName;
        } else if (otherRole == "buyer") {
          seller = myUserName;
          buyer = otherUserName;
        }

        // 거래글 정보 가져오기
        Map<String, dynamic> data =
            await SpringApi().getChatTransactionInfo(sellerId!, tradeId!);
        TradeAppointmentDto trade = TradeAppointmentDto.fromJson(data);
        tradeId = trade.id.toString();
        tradeTitle = trade.title;
        countryCode = trade.countryCode;
        type = trade.type;
        status = trade.status;
        thumbnailImageUrl = trade.thumbnailImage;
        koreanWonAmount = trade.koreanWonAmount;
        foreignCurrencyAmount = trade.foreignCurrencyAmount;
        apptStream = await DatabaseMethods().getTradeInfo(tradeId!);
        if (status != "WAIT") {


          // Map<String, dynamic> tradeDetailInfo =
          //     await DatabaseMethods().getTradeInfo(tradeId!);
          // deliveryAddress = tradeDetailInfo['deliveryAddress'];
          // deliveryAddressDetail = tradeDetailInfo['deliveryAddressDetail'];
          // deliveryAddressZipCode = tradeDetailInfo['deliveryAddressZipCode'];
          // deliveryRecipientName = tradeDetailInfo['deliveryRecipientName'];
          // deliveryRecipientTel = tradeDetailInfo['deliveryRecipientTel'];
          // directTradeLocationDetail =
          //     tradeDetailInfo['directTradeLocationDetail'];
          // directTradeTime = tradeDetailInfo['directTradeTime'];
          // sellerAccountBankCode = tradeDetailInfo['sellerAccountBankCode'];
          // sellerAccountNumber = tradeDetailInfo['sellerAccountNumber'];
          // trackingNumber = tradeDetailInfo['trackingNumber'];
        }

        break;

      /**
     * 거래글 -> 채팅방
     */
      case InfoType.TRADE:
        // 채팅 참여자 정보 설정하기
        // 새로 만들 시, 상대방은 seller 사용자는 buyer
        seller = widget.tradeInfoMap?['seller'];
        sellerId = widget.tradeInfoMap?['sellerId'];
        tradeId = widget.tradeInfoMap?['tradeId'];
        buyer = myUserName;
        buyerId = myUserId;
        otherUserName = seller;
        otherUserId = sellerId;
        otherRole = "seller";
        myRole = "buyer";

        // 거래글 정보 가져오기
        Map<String, dynamic> data =
            await SpringApi().getChatTransactionInfo(sellerId, tradeId);
        TradeAppointmentDto trade = TradeAppointmentDto.fromJson(data);
        tradeTitle = trade.title;
        countryCode = trade.countryCode;
        type = trade.type;
        status = trade.status;
        thumbnailImageUrl = trade.thumbnailImage;
        koreanWonAmount = trade.koreanWonAmount;
        foreignCurrencyAmount = trade.foreignCurrencyAmount;

        if (status != "WAIT") {
          // Map<String, dynamic> tradeDetailInfo =
          //     await DatabaseMethods().getTradeInfo(tradeId!);
          // deliveryAddress = tradeDetailInfo['deliveryAddress'];
          // deliveryAddressDetail = tradeDetailInfo['deliveryAddressDetail'];
          // deliveryAddressZipCode = tradeDetailInfo['deliveryAddressZipCode'];
          // deliveryRecipientName = tradeDetailInfo['deliveryRecipientName'];
          // deliveryRecipientTel = tradeDetailInfo['deliveryRecipientTel'];
          // directTradeLocationDetail =
          //     tradeDetailInfo['directTradeLocationDetail'];
          // directTradeTime = tradeDetailInfo['directTradeTime'];
          // sellerAccountBankCode = tradeDetailInfo['sellerAccountBankCode'];
          // sellerAccountNumber = tradeDetailInfo['sellerAccountNumber'];
          // trackingNumber = tradeDetailInfo['trackingNumber'];
        }

        chatRoomId = "${tradeId!}_${sellerId!}_${buyerId!}";

        // user 정보에 새 채팅방 목록 추가
        Map<String, dynamic> chatRoomListInfoMap = {
          "sellerId": sellerId,
          "buyerId": buyerId,
        };
        print("user에 chatlist update: ${tradeId}");
        DatabaseMethods().setUserChatList(
            sellerId!, buyerId!, chatRoomId!, chatRoomListInfoMap);
        break;

      case InfoType.NONE:
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

  Widget header(){
    return StreamBuilder(
      stream: apptStream,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> tradeDetailInfo = snapshot.data ?? {};
          appointmentType = calculateAppointmentType(tradeDetailInfo);
          print('새로 스트림: ${tradeDetailInfo['type']}');
        }

        print('$appointmentType');

        return Visibility(
          visible: _shouldShowGestureDetector(appointmentType),
          child: GestureDetector(
            onTap: () async {
              String? appt;
              // 약속 잡기
              if (appointmentType == AppointmentType.waitSeller) {

                appt = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AppointmentPage(
                              tradeInfoMap : {
                                "tradeId" : tradeId,
                                "tradeTitle" : tradeTitle,
                                "countryCode" : countryCode,
                                "thumbnailImageUrl" : thumbnailImageUrl,
                                "foreignCurrencyAmount" : foreignCurrencyAmount,
                                "koreanWonAmount" :koreanWonAmount,
                              },
                            )));
              }
              // 직거래 약속 정보 수정 페이지
              else if (appointmentType ==
                  AppointmentType.progressSellerDirect) {
              }
              // 택배거래 송장번호 입력 페이지
              else if (appointmentType ==
                  AppointmentType.progressSellerDeliveryBefore) {
              }
              // 택배거래 송장번호 수정 페이지
              else if (appointmentType ==
                  AppointmentType.progressSellerDeliveryAfter) {
              }
              // 택배거래 수령확인 액션
              else if (appointmentType ==
                  AppointmentType.progressBuyerDeliveryAfter) {
              } else {}

              setState(() {
                _appt = appt!;
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              height: _appt == "약속 잡기" ? 40 : null,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color(0xFFFFD954),
              ),
              child: Center(
                  child: Text(
                    _appt ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        );
      },
    );
  }
  AppointmentType calculateAppointmentType(Map<String, dynamic> tradeDetailInfo) {
    // final String status = tradeDetailInfo['status'];
    // final String myRole = tradeDetailInfo['myRole'];
    final String type = tradeDetailInfo['type'];
    final String trackingNumber = tradeDetailInfo['trackingNumber'];

    if (status == "WAIT") {
      if (myRole == "seller") {
        return AppointmentType.waitSeller;
      }
    } else if (status == "PROGRESS") {
      if (myRole == "seller") {
        if (type == "DIRECT") {
          return AppointmentType.progressSellerDirect;
        } else if (type == "DELIVERY") {
          if (trackingNumber == null) {
            return AppointmentType.progressSellerDeliveryBefore;
          } else {
            return AppointmentType.progressSellerDeliveryAfter;
          }
        }
      }
    } else if (status == "COMPLETE") {
      // 거래가 완료된 경우에 대한 로직 추가
    }

    // 기본적으로 다른 상황에 대한 처리 또는 기본값 설정
    return AppointmentType.progressOther;
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
          "transactionId": tradeId,
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
                          margin: const EdgeInsets.fromLTRB(20, 15, 10, 15),
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
                                  tradeTitle ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/flag/AUD.png'),
                                              radius: 8,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${NumberFormat.decimalPattern().format(foreignCurrencyAmount.toInt())} ${countryCode}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueAccent),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${NumberFormat.decimalPattern().format(koreanWonAmount.toInt())}원',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    header(),
                    // Visibility(
                    //   visible: _shouldShowGestureDetector(appointmentType),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       String? appt;
                    //       // 약속 잡기
                    //       if (appointmentType == AppointmentType.waitSeller) {
                    //
                    //         appt = await Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                      AppointmentPage(
                    //                       tradeInfoMap : {
                    //                         "tradeId" : tradeId,
                    //                         "tradeTitle" : tradeTitle,
                    //                         "countryCode" : countryCode,
                    //                         "thumbnailImageUrl" : thumbnailImageUrl,
                    //                         "foreignCurrencyAmount" : foreignCurrencyAmount,
                    //                         "koreanWonAmount" :koreanWonAmount,
                    //                       },
                    //                     )));
                    //       }
                    //       // 직거래 약속 정보 수정 페이지
                    //       else if (appointmentType ==
                    //           AppointmentType.progressSellerDirect) {
                    //       }
                    //       // 택배거래 송장번호 입력 페이지
                    //       else if (appointmentType ==
                    //           AppointmentType.progressSellerDeliveryBefore) {
                    //       }
                    //       // 택배거래 송장번호 수정 페이지
                    //       else if (appointmentType ==
                    //           AppointmentType.progressSellerDeliveryAfter) {
                    //       }
                    //       // 택배거래 수령확인 액션
                    //       else if (appointmentType ==
                    //           AppointmentType.progressBuyerDeliveryAfter) {
                    //       } else {}
                    //
                    //       setState(() {
                    //         _appt = appt!;
                    //       });
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    //       margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    //       height: _appt == "약속 잡기" ? 40 : null,
                    //       width: double.infinity,
                    //       decoration: const BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(10),
                    //         ),
                    //         color: Color(0xFFFFD954),
                    //       ),
                    //       child: Center(
                    //           child: Text(
                    //         _appt ?? "",
                    //         style: const TextStyle(fontWeight: FontWeight.bold),
                    //       )),
                    //     ),
                    //   ),
                    // )
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
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                              child: const Icon(
                                  Icons.account_balance_wallet_outlined),
                            ),
                            const SizedBox(height: 5),
                            const Text('송금'),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            String appt = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionInfoPage()));
                            setState(() {
                              // _appt = appt;
                            });
                          },
                          child: Column(
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
                              const Text('거래 정보'),
                            ],
                          ),
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
