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

  // 채팅방 생성
  createChatRoom(
      String chatRoomId, String myUserName, String otherUserName, String boardId, Map<String, dynamic> chatRoomInfoMap, Map<String, dynamic> chatRoomListInfoMap) async {
    // 채팅방 정보 얻기
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      // 채팅방 이미 존재
      return true;
    } else {
      // 채팅방 없음
      // chatrooms에 채팅방 생성
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
      // user에 채팅방 리스트 생성
      await FirebaseFirestore.instance
      .collection("users")
      .doc(myUserName)
      .collection("chatroomList")
      .doc(boardId)
      .set(chatRoomListInfoMap);
    }
  }

  // 채팅 메시지 추가 + 유저 정보 추가
  Future addMessageUser(
    String chatRoomId,
    String messageId,
    Map<String, dynamic> messageInfoMap,
    String selectOtherUser,
    Map<String, dynamic> sellerInfoMap,
    Map<String, dynamic> buyerInfoMap,
  ) async {
    // "chatrooms"
    DocumentReference chatRoomDocRef =
        FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId);

    // "userRole"
    DocumentReference userDocRef =
        chatRoomDocRef.collection("userRole").doc(selectOtherUser);
    final snapshot = await userDocRef.get();

    // 처음 생성
    if (!snapshot.exists) {
      Map<String, dynamic> setSellerInfoMap = {
        "sellerId": sellerInfoMap['sellerId'], // 판매자 아이디
        "userName": sellerInfoMap['userName'], // 판매자 닉네임
        "isExit": false, // 나가기를 했었다면, 강제 초대
        "unRead": FieldValue.increment(1), // 안 읽음 수 증가
      };
      Map<String, dynamic> setBuyerInfoMap = {
        "buyerId": buyerInfoMap['buyerId'], // 구매자 아이디
        "userName": buyerInfoMap['userName'], // 구매자 닉네임
        "isExit": false, // 나가기를 했었다면, 강제 초대
        "unRead": FieldValue.increment(1), // 안 읽음 수 증가
      };

      await chatRoomDocRef
          .collection("userRole")
          .doc("buyer")
          .set(setSellerInfoMap);
      await chatRoomDocRef
          .collection("userRole")
          .doc("seller")
          .set(setBuyerInfoMap);
    } else {
      print(sellerInfoMap['userName']);

      selectOtherUser == "seller"
          ? await userDocRef.update(sellerInfoMap)
          : await userDocRef.update(buyerInfoMap);
    }

    // "chats" 추가
    await chatRoomDocRef.collection("chats").doc(messageId).set(messageInfoMap);
  }

  // 채팅 메시지 추가
  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
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
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection("userRole")
        .doc(userId)
        .get();
    if (ds.exists) {
      // 'fieldName' 필드의 값을 가져옵니다.
      unReadCnt = ds.get('unRead');
      print(unReadCnt);
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
Future<List<String>> getChatList(myList) async {
  List<String> dataList = [];

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms') // Firestore 컬렉션 이름을 지정하세요.
        .get();

    snapshot.docs.forEach((doc) async {
      // 각 문서에서 필요한 데이터를 가져와서 리스트에 추가
      String data = doc['your_field_name']; // 필드 이름을 지정하세요.

      // MyList에 있는 값과 일치하는 경우에만 데이터를 추가
      if (myList.contains(data)) {
        dataList.add(data);

        QuerySnapshot userRoleSnapshot = await FirebaseFirestore.instance
            .collectionGroup('userRole') // 하위 컬렉션 이름인 'messages'를 지정하세요.
            .where('userName', isEqualTo: '이병건') // 필터링 조건을 추가할 수 있습니다.
            .get();
        

      }
    });

    return dataList;
  } catch (e) {
    print('Firestore 데이터 가져오기 오류: $e');
    return dataList; // 오류 발생 시 빈 리스트 반환 또는 오류 처리 방식을 변경할 수 있습니다.
  }
}






// 유저
// 내 채팅 목록
// 라스트 메시지
// 라스트 메시지 시간
// 안읽음

// 상대방 이름
// 상대방 이미지
// 게시글 아이디
// 게시글 프로필
}
