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
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
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
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  // 채팅 메시지 추가 + 유저 정보 추가
  Future addMessageUser(
      String chatRoomId,
      String messageId,
      Map<String, dynamic> messageInfoMap,
      String userId,
      Map<String, dynamic> userInfoMap) async {
    // "chatrooms"
    DocumentReference chatRoomDocRef =
        FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId);

    // "user"
    DocumentReference userDocRef =
        chatRoomDocRef.collection("user").doc(userId);
    final snapshot = await userDocRef.get();
    // 처음 생성
    if(!snapshot.exists){
      Map<String, dynamic> setUserInfoMap = {
        "userName" : userInfoMap['userName'],
        "isExit" : false,
        "unRead" : 0,
      };
      await userDocRef.set(setUserInfoMap);
    }else{
      await userDocRef.update(userInfoMap);
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
    final documentReference =  FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).collection("user").doc(userId);
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
   DocumentSnapshot documentSnapshot =
       await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).collection("user").doc(userId).get();
   if (documentSnapshot.exists) {
     // 'fieldName' 필드의 값을 가져옵니다.
     unReadCnt = documentSnapshot.get('unRead');
     print(unReadCnt);
   } else {
     print('존재하지 않습니다.');
   }
   return unReadCnt;
 }

  // 유저 정보 가져오기

}
