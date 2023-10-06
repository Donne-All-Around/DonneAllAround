import 'dart:async';

import 'package:a705/chatting_page.dart';
import 'package:a705/models/ChatsDto.dart';
import 'package:a705/models/TradeAppointmentDto.dart';
import 'package:a705/providers/trade_providers.dart';
import 'package:a705/providers/database.dart';
import 'package:a705/appointment_page.dart';
import 'package:a705/review_create_page.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:a705/transaction_info_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'delivery_transaction_page.dart';

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
  progressBuyerDeliveryAccount, // 예약 중, 구매자, 택배 거래, 계좌 송금
  progressSellerDeliveryAccount, // 예약 중, 판매자, 택배 거래, 계좌 송금
  progressBuyerDeliveryBefore, // 예약 중, 구매자, 택배 거래, 동네 페이, 송금 전
  progressBuyerDeliveryAfter, // 예약 중, 구매자, 택배 거래, 동네 페이, 송금 전
  progressSellerDeliveryBefore, // 예약 중, 판매자, 택배 거래, 동네 페이, 송금 전
  progressSellerDeliveryAfter, // 예약 중, 판매자, 택배 거래, 동네 페이, 송금 전
  progressOther, // 예약 중, 타 사용자
  completeDirectSeller, // 거래 완료, 직거래, 판매자
  completeDeliverySeller, // 거래 완료, 택배 거래, 판매자
  completeDirectBuyer, // 거래 완료, 직거래, 구매자
  completeDeliveryBuyer, // 거래 완료, 택배 거래, 구매자
  completeOther, // 거래 완료, 타 사용자
}

class _ChattingDetailPageState extends State<ChattingDetailPage> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = false;
  bool showHeader = false;
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
      finalBuyerId, // 최종 구매자
      directTradeTime, // 직거래 약속 시간
      directTradeLocationDetail, // 직거래 상제 장소
      sellerAccountBankCode, // 판매자 은행 코드
      sellerAccountNumber, // 판매자 은행 계좌번호
      deliveryRecipientName, // 택배거래 구매자 이름
      deliveryRecipientTel, // 택배거래 구매자 번호
      deliveryAddressZipCode, // 택버거래 주소 우편번호
      deliveryAddress, // 택배거래 주소
      deliveryAddressDetail, // 택배거래 상세 주소
      trackingNumber, // 송장번호
      method; // 송금 방법
  int foreignCurrencyAmount = 0, koreanWonAmount = 0;
  String? _appt;
  Stream? messageStream, apptStream;
  bool? isSellerExit,
      isBuyerExit,
      isRemittance,
      sellerReview,
      buyerReview; // 동네 페이 송금 여부
  bool isBlank = false;
  AppointmentType appointmentType = AppointmentType.waitBuyer;
  Future? tradeData;

  // 채팅방 정보 가져오기
  getUserInfo() async {
    myUserName = "신짱구";
    myUserId = "3";
    setState(() {});
  }

  // 로드
  ontheload() async {
    await getUserInfo(); // 내 정보 가져오기
    if (widget.tradeInfoMap != null || widget.chatRoomListInfoMap != null) {
      await _initializeInfo(
          widget.tradeInfoMap, widget.chatRoomListInfoMap); // 거래글 가져오기
    }

    print("init 1. 채팅 내역 가져오기");
    await getAndSetMessages(); // 채팅 내역 가져오기
    tradeData = _fatchTradeData();
    print("init 3. 거래 상세 정보 가져오기");
    apptStream = await DatabaseMethods().getTradeInfo(tradeId!);
    // 거래글 생성할 때 실행
    // DatabaseMethods().setDefaultTradeInfo(sellerId!, tradeId!);
    print("I'm $myRole");
    setState(() {});
  }

  // 초기화
  @override
  void initState() {
    super.initState();
    ontheload();
  }

  _fatchTradeData() async {
    print("init 2. 거래 정보 가져오기");
    Map<String, dynamic> data =
        await TradeProviders().getChatTransactionInfo(sellerId!, tradeId!);
    TradeAppointmentDto trade = TradeAppointmentDto.fromJson(data);

    tradeId = trade.id.toString();
    tradeTitle = trade.title;
    countryCode = trade.countryCode;
    type = trade.type;
    status = trade.status;
    thumbnailImageUrl = trade.thumbnailImage;
    koreanWonAmount = trade.koreanWonAmount;
    // await Future.delayed(Duration(milliseconds: 500));
    return data;
  }

  bool _shouldShowHeader(AppointmentType appointmentType) {
    if (appointmentType == AppointmentType.waitBuyer) {
      return false;
    } else {
      return true;
    }
  }

  bool _shouldShowTradeInfo(AppointmentType appointmentType) {
    if (appointmentType == AppointmentType.waitBuyer ||
        appointmentType == AppointmentType.waitSeller ||
        appointmentType == AppointmentType.progressOther ||
        appointmentType == AppointmentType.completeOther) {
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
  Widget chatMessageTile(String message, bool sendByMe, String ts, bool showTs,
      bool showProfile, bool showNotice) {
    return showNotice
        ? Container(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Color(0xFFFFD954),
                        width: 2,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${otherUserName} 님",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 16)),
                          Text("과의 거래는 어떠셨나요?", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("거래 후기",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 16)),
                          Text("를 남겨보아요.", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          int tradeID = 0;
                          if(tradeId != null){
                            tradeID = int.parse(tradeId ?? "0");
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewCreatePage(tradeID: tradeID)));
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          height: 40,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: Color(0xFFFFD954),
                          ),
                          child: Center(
                              child: Text(
                            "거래 후기 남기러 가기",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Row(
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
                              : const Padding(
                                  padding: EdgeInsets.only(left: 66.0)),
                          const SizedBox(height: 10)
                        ],
                      ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: sendByMe
                                ? Radius.circular(18)
                                : Radius.circular(0),
                            bottomRight: Radius.circular(18),
                            topRight: sendByMe
                                ? Radius.circular(0)
                                : Radius.circular(18),
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
  // Widget chatMessage() {
  //   return NotificationListener<ScrollUpdateNotification>(
  //     child: StreamBuilder<QuerySnapshot>(
  //       stream: _stream,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //
  //         if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         }
  //
  //         List<DocumentSnapshot> documents = snapshot.data!.docs;
  //
  //         return ListView.builder(
  //           controller: scrollController,
  //           itemCount: documents.length,
  //           itemBuilder: (context, index) {
  //             final data = documents[index].data() as Map<String, dynamic>;
  //             return ListTile(
  //               title: Text(data['message']),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

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

                    bool showNotice = ds["type"] == "NOTICE";

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
                      showNotice,
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

  // 거래 상태 헤더 Stream
  Widget _header() {
    return StreamBuilder(
      stream: apptStream,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> tradeDetailInfo = snapshot.data ?? {};
          appointmentType = calculateAppointmentType(tradeDetailInfo);
          print('거래 상태 변경: ${tradeDetailInfo['type']}');
        }
        print('현재 약속 타입: $appointmentType');
        return Visibility(
          visible: _shouldShowHeader(appointmentType),
          child: GestureDetector(
            onTap: () async {
              // 약속 잡기
              if (appointmentType == AppointmentType.waitSeller) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentPage(
                              tradeInfoMap: {
                                "tradeId": tradeId,
                                "tradeTitle": tradeTitle,
                                "countryCode": countryCode,
                                "thumbnailImageUrl": thumbnailImageUrl,
                                "foreignCurrencyAmount": foreignCurrencyAmount,
                                "koreanWonAmount": koreanWonAmount,
                                "buyerId": buyerId,
                              },
                            )));
              }
              // 직거래 약속 정보 수정 페이지
              else if (appointmentType ==
                  AppointmentType.progressSellerDirect) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionInfoPage(
                      tradeInfoMap: {
                        "tradeId": tradeId,
                        "tradeTitle": tradeTitle,
                        "countryCode": countryCode,
                        "thumbnailImageUrl": thumbnailImageUrl,
                        "foreignCurrencyAmount": foreignCurrencyAmount,
                        "koreanWonAmount": koreanWonAmount,
                        "buyerId": buyerId,
                        "directTradeLocationDetail": directTradeLocationDetail,
                        "directTradeTime": directTradeTime,
                        "appointmentType": appointmentType,
                      },
                    ),
                  ),
                );
                setState(() {});
              }
              // 택배거래 거래 정보 페이지
              else if (appointmentType ==
                      AppointmentType.progressSellerDeliveryBefore ||
                  appointmentType ==
                      AppointmentType.progressSellerDeliveryAfter ||
                  appointmentType ==
                      AppointmentType.progressBuyerDeliveryAccount) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryTransactionPage(
                      tradeInfoMap: {
                        "tradeId": tradeId,
                        "tradeTitle": tradeTitle,
                        "countryCode": countryCode,
                        "thumbnailImageUrl": thumbnailImageUrl,
                        "foreignCurrencyAmount": foreignCurrencyAmount,
                        "koreanWonAmount": koreanWonAmount,
                        "buyerId": buyerId,
                        "deliveryAddress": deliveryAddress,
                        "deliveryAddressDetail": deliveryAddressDetail,
                        "deliveryAddressZipCode": deliveryAddressZipCode,
                        "deliveryRecipientName": deliveryRecipientName,
                        "deliveryRecipientTel": deliveryRecipientTel,
                        "sellerAccountBankCode": sellerAccountBankCode,
                        "sellerAccountNumber": sellerAccountNumber,
                        "sellerId": sellerId,
                        "trackingNumber": trackingNumber,
                        "appointmentType": appointmentType,
                      },
                    ),
                  ),
                );
              }
              // 거래 완료 메소드 실행
              else if (appointmentType ==
                  AppointmentType.progressSellerDeliveryAccount) {
                setCompleteAppointment();
              }
              // 송금 페이지로 이동
              else if (appointmentType ==
                  AppointmentType.progressBuyerDeliveryBefore) {
              }
              // 판매자에게 송금 메소드 실행
              else if (appointmentType ==
                  AppointmentType.progressBuyerDeliveryAfter) {
              } else {
                // 이동 X
              }
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              height: _appt == "약속 잡기" ? 40 : null,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
                color: Color(0xFFFFD954),
              ),
              child: Center(
                  child: Text(
                _appt ?? "",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        );
      },
    );
  }

  AppointmentType calculateAppointmentType(
      Map<String, dynamic> tradeDetailInfo) {
    status = tradeDetailInfo['status'];
    type = tradeDetailInfo['type'];
    trackingNumber = tradeDetailInfo['trackingNumber'];
    directTradeLocationDetail = tradeDetailInfo['directTradeLocationDetail'];
    directTradeTime = tradeDetailInfo['directTradeTime'];
    finalBuyerId = tradeDetailInfo['buyerId'];
    method = tradeDetailInfo['method'];
    isRemittance = tradeDetailInfo['isRemittance'];
    sellerReview = tradeDetailInfo['sellerReview'];
    buyerReview = tradeDetailInfo['buyerReview'];
    deliveryAddress = tradeDetailInfo['deliveryAddress'];
    deliveryAddressDetail = tradeDetailInfo['deliveryAddressDetail'];
    deliveryAddressZipCode = tradeDetailInfo['deliveryAddressZipCode'];
    deliveryRecipientName = tradeDetailInfo['deliveryRecipientName'];
    deliveryRecipientTel = tradeDetailInfo['deliveryRecipientTel'];
    sellerAccountBankCode = tradeDetailInfo['sellerAccountBankCode'];
    sellerAccountNumber = tradeDetailInfo['sellerAccountNumber'];

    switch (status) {
      case "WAIT":
        // 구매(희망)자
        if (myRole == "buyer") {
          return AppointmentType.waitBuyer;
        }
        // 판매자
        else if (myRole == "seller") {
          _appt = "약속 잡기";
          return AppointmentType.waitSeller;
        }
        break;
      case "PROGRESS":
        // 구매자
        if (myRole == "buyer" && finalBuyerId == myUserId) {
          // 직거래
          if (type == "DIRECT") {
            if (isComplete(directTradeTime)) {
              // 약속 일시 후
              // 거래 완료로 바꾸는 메소드 실행
              setCompleteAppointment();
              _appt = "거래 완료";
              return AppointmentType.completeDirectBuyer;
            } else {
              // 약속 일시 전
              _appt = "${directTradeLocationDetail}\n${directTradeTime}";
              return AppointmentType.progressBuyerDirect;
            }
          }
          // 택배거래
          else if (type == "DELIVERY") {
            if (method == "ACCOUNT") {
              _appt = "거래 정보"; // 거래 정보 페이지로 이동
              return AppointmentType.progressBuyerDeliveryAccount;
            } else {
              if (isRemittance == true) {
                _appt = "수령 확인"; // 판매자에게 송금
                return AppointmentType.progressBuyerDeliveryAfter;
              } else if (isRemittance == false) {
                _appt = "동네 페이 송금"; // 송금 페이지로 이동
                return AppointmentType.progressBuyerDeliveryBefore;
              }
            }
          }
        }
        // 판매자
        else if (myRole == "seller") {
          // 직거래
          if (type == "DIRECT") {
            if (isComplete(directTradeTime)) {
              setCompleteAppointment();
              _appt = "거래 완료";
              return AppointmentType.completeDirectSeller;
            } else {
              _appt = "${directTradeLocationDetail}\n${directTradeTime}";
              return AppointmentType.progressSellerDirect;
            }
          }
          // 택배거래
          else if (type == "DELIVERY") {
            if (method == "ACCOUNT") {
              _appt = "거래 완료 하기"; // yellow background, 거래 완료 실행
              return AppointmentType.progressSellerDeliveryAccount;
            } else {
              if (isRemittance == true) {
                _appt = "아직 수령하지 않았어요"; // 안내
                return AppointmentType.progressSellerDeliveryAfter;
              } else if (isRemittance == false) {
                _appt = "아직 송금하지 않았어요"; // 안내
                return AppointmentType.progressSellerDeliveryBefore;
              }
            }
          }
        }
        // 타 사용자
        else {
          _appt = "거래 중"; // 안내
          return AppointmentType.progressOther;
        }
        break;
      case "COMPLETE":
        _appt = "거래 완료"; // white background, 안내
        // 구매자
        if (myRole == "buyer" && finalBuyerId == myUserId) {
          if (buyerReview != true) {
            // 메시지에 거래 후기 작성 안내 알림 추가
            setNotificationRiview();
          }
          if (type == "DIRECT") {
            return AppointmentType.completeDirectBuyer;
          } else {
            return AppointmentType.completeDeliveryBuyer;
          }
        }
        // 판매자
        else if (myRole == "seller") {
          if (sellerReview != true) {
            // 메시지에 거래 후기 작성 안내 알림 추가
            setNotificationRiview();
          }
          if (type == "DIRECT") {
            return AppointmentType.completeDirectSeller;
          } else {
            return AppointmentType.completeDeliverySeller;
          }
        }
        // 타 사용자
        else {
          return AppointmentType.completeOther;
        }
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
        "type": "MESSAGE",
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

      // 마지막 메시지
      DatabaseMethods()
          .addMessageUser(chatRoomId!, messageInfoMap, otherRole!, myRole!,
              sellerInfoMap, buyerInfoMap)
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
    myRole = myUserName == seller ? "seller" : "buyer";
    DatabaseMethods().setRead(chatRoomId, myRole); // 읽음 처리
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //   child: GestureDetector(
      // onTap: () {
      //   // FocusManager.instance.primaryFocus?.unfocus();
      //   // setState(() {
      //   //   isVisible = false;
      //   // });
      // },
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
              otherUserName ?? "",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FutureBuilder(
                future: tradeData,
                // 비동기 작업을 호출하는 Future를 지정
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
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
                              Shimmer.fromColors(
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 15, 10, 15),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(240, 240, 240, 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(),
                                  ),
                                  baseColor: Color.fromRGBO(240, 240, 240, 1),
                                  highlightColor: Colors.white),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Shimmer.fromColors(
                                              child: Container(
                                                height: 25,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      240, 240, 240, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              baseColor: Color.fromRGBO(
                                                  240, 240, 240, 1),
                                              highlightColor: Colors.white)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Shimmer.fromColors(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 3, 0, 3),
                                                        height: 20,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              240, 240, 240, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      baseColor:
                                                          const Color.fromRGBO(
                                                              240, 240, 240, 1),
                                                      highlightColor:
                                                          Colors.white)
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Shimmer.fromColors(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 20, 3),
                                                        height: 20,
                                                        width: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              240, 240, 240, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      baseColor: Color.fromRGBO(
                                                          240, 240, 240, 1),
                                                      highlightColor:
                                                          Colors.white)
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
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text("error");
                  } else {
                    return Container(
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
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      height: 60,
                                      image: NetworkImage(
                                        thumbnailImageUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            tradeTitle ?? "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.more_horiz,
                                              color: Colors.black87,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                      height: 220,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        // 모달 배경색
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              _cancelDialog(),
                                                              _declarationDialog(),
                                                            ]),
                                                      ));
                                                },
                                                backgroundColor: Colors
                                                    .transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
                                              );
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints:
                                                const BoxConstraints(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
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
                                                        'assets/images/flag/${countryCode == 'KRW' ? 'KRW' : countryCode == 'USD' ? 'USDKRW' : 'USD${countryCode}'}.png'),
                                                    radius: 8,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '${NumberFormat.decimalPattern().format(foreignCurrencyAmount.toInt())} ${countryCode}' ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${NumberFormat.decimalPattern().format(koreanWonAmount.toInt())}원' ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(width: 20),
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
                          _header(),
                        ],
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: chatMessage(),
              ),
              Container(
                color: const Color(0xFFFFD954),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          isVisible = !isVisible;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
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
                    SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        addMessage(true);
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(
                      width: 12,
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
                            if (_shouldShowTradeInfo(appointmentType)) {
                              if (appointmentType ==
                                      AppointmentType.progressSellerDirect ||
                                  appointmentType ==
                                      AppointmentType.completeDirectBuyer ||
                                  appointmentType ==
                                      AppointmentType.completeDirectSeller) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionInfoPage(
                                      tradeInfoMap: {
                                        "tradeId": tradeId,
                                        "tradeTitle": tradeTitle,
                                        "countryCode": countryCode,
                                        "thumbnailImageUrl": thumbnailImageUrl,
                                        "foreignCurrencyAmount":
                                            foreignCurrencyAmount,
                                        "koreanWonAmount": koreanWonAmount,
                                        "buyerId": buyerId,
                                        "directTradeLocationDetail":
                                            directTradeLocationDetail,
                                        "directTradeTime": directTradeTime,
                                        "appointmentType": appointmentType,
                                      },
                                    ),
                                  ),
                                );
                                setState(() {});
                              } else if (appointmentType ==
                                  AppointmentType.progressBuyerDirect) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      // title: Text("안내"),
                                      content: Text("판매자가 거래 정보를 입력중이에요."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the dialog
                                          },
                                          child: Text("확인"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryTransactionPage(
                                      tradeInfoMap: {
                                        "tradeId": tradeId,
                                        "tradeTitle": tradeTitle,
                                        "countryCode": countryCode,
                                        "thumbnailImageUrl": thumbnailImageUrl,
                                        "foreignCurrencyAmount":
                                            foreignCurrencyAmount,
                                        "koreanWonAmount": koreanWonAmount,
                                        "buyerId": buyerId,
                                        "deliveryAddress": deliveryAddress,
                                        "deliveryAddressDetail":
                                            deliveryAddressDetail,
                                        "deliveryAddressZipCode":
                                            deliveryAddressZipCode,
                                        "deliveryRecipientName":
                                            deliveryRecipientName,
                                        "deliveryRecipientTel":
                                            deliveryRecipientTel,
                                        "sellerAccountBankCode":
                                            sellerAccountBankCode,
                                        "sellerAccountNumber":
                                            sellerAccountNumber,
                                        "sellerId": sellerId,
                                        "trackingNumber": trackingNumber,
                                        "appointmentType": appointmentType,
                                      },
                                    ),
                                  ),
                                );
                                setState(() {});
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    // title: Text("안내"),
                                    content: Text("거래 약속을 잡지 않았어요."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text("확인"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
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
      // )
    );
  }

  bool isComplete(String? directTradeTime) {
    String dateString = directTradeTime!;
    DateTime parsedDateTime = parseKoreanDateTime(dateString);
    DateTime now = DateTime.now().add(Duration(hours: 9));
    // 비교
    if (now.isBefore(parsedDateTime)) {
      print("약속 시간이 지나지 않았습니다.");
      return false;
    } else {
      print("약속 시간이 지났습니다.");
      return true;
    }
  }

  DateTime parseKoreanDateTime(String dateString) {
    return DateFormat('yyyy년 MM월 dd일 a hh시 mm분', 'ko').parseLoose(dateString);
  }

  void setCompleteAppointment() {
    Map<String, dynamic> tradeInfo = {
      "status": "COMPLETE",
    };
    TradeProviders().setCompleteAppointment(tradeId!, myUserId!);
    DatabaseMethods().updateTradeInfo(tradeId!, tradeInfo);
    print(tradeInfo.toString());
  }

  void setNotificationRiview() {
    // chatrooms 메시지에 안내 메시지 추가
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('h:mma').format(now.add(Duration(hours: 9))); // UT
    Map<String, dynamic> noticeInfoMap = {
      "message": "",
      "sendBy": "admin",
      "ts": formattedDate, // timestamp
      "time": FieldValue.serverTimestamp(),
      "imgUrl": "",
      "type": "NOTICE",
    };
    DatabaseMethods().addMessage(chatRoomId!, noticeInfoMap);
    // trade review true로 변경
    Map<String, dynamic> tradeInfoMap = {"${myRole}Review": true};
    DatabaseMethods().updateTradeInfo(tradeId!, tradeInfoMap);
  }

  void cancelAppointment() {
    TradeProviders().cancelAppointment(tradeId!, myUserId!);
    DatabaseMethods().setDefaultTradeInfo(sellerId!, tradeId!);
  }

  bool showMoreModal() {
    if (appointmentType == AppointmentType.progressSellerDeliveryAccount ||
        appointmentType == AppointmentType.progressSellerDeliveryBefore ||
        appointmentType == AppointmentType.progressSellerDirect) {
      return false;
    }
    return true;
  }

  // 취소하기
  Widget _cancelDialog() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return showMoreModal()
                ? AlertDialog(
                    // title: Text("안내"),
                    content: Text("약속을 취소할 수가 없어요."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text("확인"),
                      ),
                    ],
                  )
                : AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    content: Text("거래 약속을 취소하시겠어요?"),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(100, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade200),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: Text(
                          "아니요",
                          style: TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(100, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          "취소",
                          style: TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // 약속 취소 메소드 실행
                          cancelAppointment();
                        },
                      ),
                    ],
                  );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 17, 10, 17),
        margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: Colors.black26, width: 2.0),
        ),
        child: Center(
            child: Text(
          "약속 취소",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blueAccent),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }

  // 신고하기
  Widget _declarationDialog() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: Text("신고하시겠습니까?"),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade200),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text(
                    "아니요",
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    "신고하기",
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 17, 10, 17),
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: Colors.black26, width: 2.0),
        ),
        child: Center(
            child: Text(
          "신고하기",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.redAccent),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }

  Widget _errorPage() {
    // return Text("?");
    return Container(
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
              Shimmer.fromColors(
                  child: Container(
                    height: 70,
                    width: 70,
                    margin: const EdgeInsets.fromLTRB(20, 15, 10, 15),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(),
                  ),
                  baseColor: Color.fromRGBO(240, 240, 240, 1),
                  highlightColor: Colors.white),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Shimmer.fromColors(
                              child: Container(
                                height: 25,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              baseColor: Color.fromRGBO(240, 240, 240, 1),
                              highlightColor: Colors.white)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Shimmer.fromColors(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                        height: 20,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(240, 240, 240, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      baseColor:
                                          Color.fromRGBO(240, 240, 240, 1),
                                      highlightColor: Colors.white)
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Shimmer.fromColors(
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 20, 3),
                                        height: 20,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(240, 240, 240, 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      baseColor:
                                          Color.fromRGBO(240, 240, 240, 1),
                                      highlightColor: Colors.white)
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
        ],
      ),
    );
    // return Container(
    //   color: Colors.white, // 배경색
    //   child: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image(image: AssetImage('assets/images/bad_don.png')),
    //         Text("사용자 정보를 확인할 수 없습니다."),
    //       ],
    //     ),
    //   ),
    // );
  }
}
