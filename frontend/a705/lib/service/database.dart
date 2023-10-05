import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  // users 생성
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // phone 으로 user 찾기
  Future<QuerySnapshot> getUserByPhone(String phone) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("phone", isEqualTo: phone)
        .get();
  }

  // name 으로 user 찾기
  Future<QuerySnapshot> getUserByName(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  // 채팅 메시지 추가 + 유저 정보 추가
  Future addMessageUser(
    String chatRoomId,
    Map<String, dynamic> messageInfoMap,
    String otherRole,
    String myRole,
    Map<String, dynamic> sellerInfoMap,
    Map<String, dynamic> buyerInfoMap,
  ) async {
    // "chatrooms"
    DocumentReference chatRoomDocRef =
        FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId);

    // "userRole"
    DocumentReference userDocRef =
        chatRoomDocRef.collection("userRole").doc(otherRole);
    final snapshot = await userDocRef.get();

    // 처음 userRole 생성
    if (!snapshot.exists) {
      Map<String, dynamic> setSellerInfoMap = {
        "sellerId": sellerInfoMap['sellerId'], // 판매자 아이디
        "userName": sellerInfoMap['userName'], // 판매자 닉네임
        "isExit": false, // 나가기를 했었다면, 강제 초대
        "unRead": 0, // 안 읽음
      };
      Map<String, dynamic> setBuyerInfoMap = {
        "buyerId": buyerInfoMap['buyerId'], // 구매자 아이디
        "userName": buyerInfoMap['userName'], // 구매자 닉네임
        "isExit": false, // 나가기를 했었다면, 강제 초대
        "unRead": 0, // 안 읽음
      };

      await chatRoomDocRef
          .collection("userRole")
          .doc("buyer")
          .set(setBuyerInfoMap);
      await chatRoomDocRef
          .collection("userRole")
          .doc("seller")
          .set(setSellerInfoMap);
    }

    print(sellerInfoMap['userName']);

    otherRole == "seller"
        ? await userDocRef.update(sellerInfoMap)
        : await userDocRef.update(buyerInfoMap);
    final updatedFiled = {
      'isExit': false,
    };
    DocumentReference myDocRef =
        chatRoomDocRef.collection("userRole").doc(myRole);

    try {
      await myDocRef.update(updatedFiled);
      print('업데이트 성공');
    } catch (e) {
      print('업데이트 실패: $e');
    }

    // user에 chatlist 저장

    // "chats" 추가
    await chatRoomDocRef.collection("chats").doc().set(messageInfoMap);
  }

  // 채팅 메시지 추가
  Future addMessage(String chatRoomId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc()
        .set(messageInfoMap);
  }

  // 채팅 마지막 메시지 업데이트
  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set(lastMessageInfoMap);
  }

  // 채팅 내역 조회
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  setRead(chatRoomId, userId) async {
    final documentReference = FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("userRole")
        .doc(userId);
    // 업데이트할 필드와 값을 지정합니다.
    final updatedField = {
      'unRead': 0,
    };

    try {
      await documentReference.update(updatedField);
      print('업데이트 성공');
    } catch (e) {
      print('업데이트 실패: $e');
    }
  }

  // 상대방의 안 읽음 개수 조회
  getUnreadCnt(chatRoomId, userId) async {
    dynamic unReadCnt = 0;
    print("안읽음 개수 조회할 userId : $userId");
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection("userRole")
        .doc(userId)
        .get();
    if (ds.exists) {
      // 'fieldName' 필드의 값을 가져옵니다.
      unReadCnt = ds.get('unRead');
      // print(unReadCnt);
    } else {
      print('존재하지 않습니다.');
    }
    return unReadCnt;
  }

  // 유저 정보 가져오기
  Future<QuerySnapshot<Map<String, dynamic>>> getChatRoom() async {
    return await FirebaseFirestore.instance.collection("chatrooms").get();
  }

  // 거래 내역 조회
  Future<Stream<QuerySnapshot>> getTransaction() async {
    return FirebaseFirestore.instance.collection("transactions").snapshots();
  }

  // 채팅
  Future<Map<String, dynamic>> getChatList(List<String> myList) async {
    Map<String, dynamic> chatList = {};
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('chatrooms').get();

      for (int i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot doc = snapshot.docs[i];
        if (myList.contains(doc.id)) {
          // 내 채팅목록만 가져오기
          Object? listData = doc.data();
          // print(listData);
          DocumentReference seller =
              doc.reference.collection("userRole").doc("seller");
          DocumentReference buyer =
              doc.reference.collection("userRole").doc("buyer");

          // userRole의 데이터를 가져옵니다.
          DocumentSnapshot sellerDs = await seller.get();
          DocumentSnapshot buyerDs = await buyer.get();

          Object? sellerData = sellerDs.data();
          Object? buyerData = buyerDs.data();

          // chatList에 데이터를 추가합니다.
          chatList[doc.id] = {
            "list": listData,
            "seller": sellerData,
            "buyer": buyerData,
          };
          // print(chatList);
        }
      }
      return chatList;
    } catch (e) {
      print('Firestore 데이터 가져오기 오류: $e');
    }
    return chatList;
  }

  // users에 chatlist 추가
  setUserChatList(String sellerId, String buyerId, String transactionId,
      Map<String, dynamic> chatRoomListInfoMap) async {
    try{
      await FirebaseFirestore.instance
          .collection("user")
          .doc(sellerId)
          .collection("chatroomList")
          .doc(transactionId)
          .set(chatRoomListInfoMap);
      await FirebaseFirestore.instance
          .collection("user")
          .doc(buyerId)
          .collection("chatroomList")
          .doc(transactionId)
          .set(chatRoomListInfoMap);
    }catch(e){
      print('users에 chatlist 추가 실패: $e');
    }
    
  }

  // users에서 채팅목록 조회
  Future<List<String>> getUserChatList(String myUserId) async {
    List<String> myList = [];
    try {
      // Firebase 초기화
      await Firebase.initializeApp();

      // Firestore 인스턴스 가져오기
      final db = FirebaseFirestore.instance;

      // collection을 가져오기
      final collection = db.collection('user');

      // doc 가져오기
      final docs =
          await collection.doc(myUserId).collection('chatroomList').get();

      // doc의 id를 배열에 저장
      myList = docs.docs.map((doc) => doc.id).toList();

      return myList;
    } catch (e) {
      print('Firestore 데이터 가져오기 오류: $e');
    }
    return myList;
  }

  // 나가기
  setExit(String chatroomId, String myRole) async {
    final documentReference = FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("userRole")
        .doc(myRole);

    final updatedField = {
      'isExit': true,
    };
    try {
      await documentReference.update(updatedField);
      print('업데이트 성공');
    } catch (e) {
      print('업데이트 실패: $e');
    }
  }

  // 거래 약속 잡기 기본 정보 저장
  setDefaultTradeInfo(String sellerId, String tradeId){
    Map<String, dynamic> tradeInfo = {
      "type": "DIRECT",
      "directTradeTime": null,
      "directTradeLocationDetail": null,
      "sellerAccountBankCode": null,
      "sellerAccountNumber": null,
      "deliveryRecipientName": null,
      "deliveryRecipientTel": null,
      "deliveryAddressZipCode": null,
      "deliveryAddressDetail": null,
      "deliveryAddress": null,
      "trackingNumber": null,
      "buyerId": null,
      "sellerId": sellerId,
      "status": "WAIT",
      "method": "ACCOUNT",
      "isRemittance": false,
      "sellerReview": false,
      "buyerReview": false,
    };
    try {
      FirebaseFirestore.instance
          .collection("trade")
          .doc(tradeId)
          .set(tradeInfo);
    } catch (e) {
      print('FireStore 저장 실패: $e');
    }

  }

  // 거래 약속잡기 정보 저장
  setTradeInfo(String tradeId, Map<String, dynamic> tradeInfoMap) {
    try {
      FirebaseFirestore.instance
          .collection("trade")
          .doc(tradeId)
          .set(tradeInfoMap);
    } catch (e) {
      print('FireStore 저장 실패: $e');
    }
  }

  updateTradeInfo(String tradeId, Map<String, dynamic> tradeInfoMap) {
    try {
      FirebaseFirestore.instance
          .collection("trade")
          .doc(tradeId)
          .update(tradeInfoMap);
    } catch (e) {
      print('FireStore 저장 실패: $e');
    }
  }

  // 거래 약속잡기 정보 조회
  Stream<Map<String, dynamic>> getTradeInfo(String tradeId) {
    return FirebaseFirestore.instance
        .collection("trade")
        .doc(tradeId)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }


}
