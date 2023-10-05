import 'dart:convert';
import 'package:a705/chatting_page.dart';
import 'package:http/http.dart' as http;

class SpringApi {
  // 채팅방 내 거래글 정보 가져오기
  Future<Map<String, dynamic>> getChatTransactionInfo(
      String? sellerId, String? tradeId) async {
    print('sellerId: $sellerId, tradeId: $tradeId');
    try {
      http.Response _response = await http.get(Uri.parse(
          "https://j9a705.p.ssafy.io/api/trade/chat/${tradeId}?memberId=${sellerId}"));
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);
        return data;
      } else {
        print("stauts code: ${_response.statusCode}");
        return {};
      }
    } catch (e) {
      print('조회 실패: $e');
    }
    return {};
  }

  // 약속 취소
  // 거래 완료

  // 직거래 약속 잡기
  setDirectAppointment(
      Map<String, dynamic> apptInfoMap, String tradeId, String memberId) async {
    print('tradeId: $tradeId');
    final String jsonData = json.encode(apptInfoMap);
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/direct/${tradeId}?memberId=${memberId}"),
        body: jsonData,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);
        return data;
      } else {
        print('상태 코드 오류: ${_response.statusCode}');
        return {};
      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }

  // 택배거래 약속 잡기
  setDeliveryAppointment(
      Map<String, dynamic> apptInfoMap, String tradeId, String memberId) async {
    print('tradeId: $tradeId');
    final String jsonData = json.encode(apptInfoMap);
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/delivery/${tradeId}?memberId=${memberId}"),
        body: jsonData,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print("ResponseBody : $responseBody");
        return data;
      } else {
        print('상태 코드 오류: ${_response.statusCode}');
        return {};
      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }

  // 거래 완료
  setCompleteAppointment(String tradeId, String memberId) async {
    print('tradeId: $tradeId');
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/complete/${tradeId}?memberId=${memberId}"),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);
        return data;
      } else {
        print('상태 코드 오류: ${_response.statusCode}');
        return {};
      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }

  // 약속 취소
  cancelAppointment(String tradeId, String memberId) async {
    print('tradeId: $tradeId');
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/cancel/${tradeId}?memberId=${memberId}"),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);
        return data;
      } else {
        print('상태 코드 오류: ${_response.statusCode}');
        return {};
      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }
}
