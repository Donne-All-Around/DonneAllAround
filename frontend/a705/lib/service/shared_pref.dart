import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String userIdKey = "USERKEY";
  static String userName = " USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPickKey = "USERPICKKEY";

  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }
}