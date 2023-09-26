import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:a705/dto/TransactionInfo.dart';

class SpringApi {
  Future<List<TransactionInfo>> getTransactionInfo(String transactionId) async {
    try {
      http.Response _response = await http.get(
          Uri.parse("https://j9a705.p.ssafy.io/api/trade/chat/6?memberId=3"));
      if (_response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(_response.body);

        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(data);

        // 여기에서 "data" 객체의 내용을 사용하거나 반환할 수 있습니다.
        // 예시: "id", "title" 값을 가져오기
        int id = data['id'];
        String title = data['title'];

        List<dynamic> _data = json.decode(_response.body);
        // JSON 데이터를 파싱하여 TransactionInfo 객체 리스트로 변환
        print(_data);
        List<TransactionInfo> transactions =
            _data.map((item) => TransactionInfo.fromJson(item)).toList();
        print("transaction: $transactions");
      } else {
        return [];
      }
    } catch (e) {}
    return [];
  }
}
