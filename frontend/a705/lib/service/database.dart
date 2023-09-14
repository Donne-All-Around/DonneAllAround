import 'package:cloud_firestore/cloud_firestore.dart';

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
  updateLastMessageSend(String chatRoomId, Map<String, dynamic> lastMessageInfoMap){
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set(lastMessageInfoMap);
  }

  //
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }
}
