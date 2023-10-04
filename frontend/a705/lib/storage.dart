import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveUserInfo(String id, String tel, String token) async {
  await storage.write(key: 'userId', value: id);
  await storage.write(key: 'userTel', value: tel);
  await storage.write(key: 'jwtToken', value: token);
}

Future<String?> getUserId() async {
  return await storage.read(key: 'userId');
}

Future<String?> getUserTel() async {
  return await storage.read(key: 'userTel');
}

Future<String?> getJwtToken() async {
  return await storage.read(key: 'jwtToken');
}