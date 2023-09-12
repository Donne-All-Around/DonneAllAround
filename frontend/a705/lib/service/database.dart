
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id){
    return FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);
    // async 작성 후 await 붙이기
    // return await FirebaseFirestore.instance.collection("users").doc(id).set(userInfoMap);
  }
}