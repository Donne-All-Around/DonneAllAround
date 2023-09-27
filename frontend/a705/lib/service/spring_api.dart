import 'dart:convert';
import 'package:http/http.dart' as http;

class SpringApi {

  // 채팅방 내 거래글 정보 가져오기
  Future<Map<String, dynamic>> getChatTransactionInfo(String transactionId) async {
    try {
      http.Response _response = await http.get(
          Uri.parse("https://j9a705.p.ssafy.io/api/trade/chat/6?memberId=3"));
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print('조회 실패: $e');
    }
    return {};
  }
}
