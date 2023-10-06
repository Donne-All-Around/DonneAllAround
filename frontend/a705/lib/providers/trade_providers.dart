import 'dart:convert';

import 'package:a705/models/TradeDto.dart';
import 'package:a705/providers/database.dart';
import 'package:a705/storage.dart';
import 'package:http/http.dart' as http;

class TradeProviders {
  String url = "https://j9a705.p.ssafy.io";

  // String accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAtNzk3OS03OTc5IiwiYXV0aCI6IlJPTEVfVVNFUiIsImV4cCI6MTY5NjU4ODk5M30.6tfXpAfYuARNQUcMBC7nVY-vgoX-8gDHI8zUx_1GQs0";


  // 거래 목록 조회(최신순)
  Future<List<TradeDto>> getLatestTrade(
      String countryCode,
      int? lastTradeId,
      String? country,
      String? administrativeArea,
      String? subAdministrativeArea,
      String? locality,
      String? subLocality,
      String? thoroughfare) async {
    final accessToken = await getJwtAccessToken();
    List<TradeDto> trade = [];
    final response = await http.post(
      lastTradeId == null
          ? Uri.parse('$url/api/trade/list?lastTradeId=&sort=createTime')
          : Uri.parse(
              '$url/api/trade/list?lastTradeId=$lastTradeId&sort=createTime'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      },
      body: jsonEncode({
        "countryCode": countryCode,
        "country": country,
        "administrativeArea": administrativeArea,
        "subAdministrativeArea": subAdministrativeArea,
        "locality": locality,
        "subLocality": subLocality,
        "thoroughfare": thoroughfare
      }),
    );
    if (response.statusCode == 200) {
      // List<dynamic> body = json.decode(response.body)['data']['tradeList']; // 한글 깨짐
      List<dynamic> body =
          json.decode(utf8.decode(response.bodyBytes))['data']['tradeList'];
      trade = body.map((trades) => TradeDto.fromJson(trades)).toList();
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return trade;
  }

  // 거래 목록 조회(낮은 가격순)
  Future<List<TradeDto>> getLowestTrade(
      String countryCode,
      int? lastTradeId,
      String? country,
      String? administrativeArea,
      String? subAdministrativeArea,
      String? locality,
      String? subLocality,
      String? thoroughfare) async {
    List<TradeDto> trade = [];
    final accessToken = await getJwtAccessToken();
    final response = await http.post(
      lastTradeId == null
          ? Uri.parse('$url/api/trade/list?lastTradeId=&sort=koreanWonAmount')
          : Uri.parse(
              '$url/api/trade/list?lastTradeId=$lastTradeId&sort=koreanWonAmount'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      },
      body: jsonEncode({
        "countryCode": countryCode,
        "country": country,
        "administrativeArea": administrativeArea,
        "subAdministrativeArea": subAdministrativeArea,
        "locality": locality,
        "subLocality": subLocality,
        "thoroughfare": thoroughfare
      }),
    );
    if (response.statusCode == 200) {
      // print(response.body);
      List<dynamic> body =
          json.decode(utf8.decode(response.bodyBytes))['data']['tradeList'];
      trade = body.map((trades) => TradeDto.fromJson(trades)).toList();
      // print(trade);
    }

    return trade;
  }

  // 거래 목록 조회(단위 당 낮은 가격순)
  Future<List<TradeDto>> getLowestRateTrade(
      String countryCode,
      int? lastTradeId,
      String? country,
      String? administrativeArea,
      String? subAdministrativeArea,
      String? locality,
      String? subLocality,
      String? thoroughfare) async {
    List<TradeDto> trade = [];
    final accessToken = await getJwtAccessToken();
    final response = await http.post(
      lastTradeId == null
          ? Uri.parse(
              '$url/api/trade/list?lastTradeId=&sort=koreanWonPerForeignCurrency')
          : Uri.parse(
              '$url/api/trade/list?lastTradeId=$lastTradeId&sort=koreanWonPerForeignCurrency'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      },
      body: jsonEncode({
        "countryCode": countryCode,
        "country": country,
        "administrativeArea": administrativeArea,
        "subAdministrativeArea": subAdministrativeArea,
        "locality": locality,
        "subLocality": subLocality,
        "thoroughfare": thoroughfare
      }),
    );
    if (response.statusCode == 200) {
      // print(response.body);
      List<dynamic> body =
          json.decode(utf8.decode(response.bodyBytes))['data']['tradeList'];
      trade = body.map((trades) => TradeDto.fromJson(trades)).toList();
      // print(trade);
    }
    return trade;
  }

  // 거래 내역 조회(거래 완료)
  Future<List<TradeDto>> getTradeHistory(int lastTradeId) async {
    List<TradeDto> trade = [];
    final accessToken = await getJwtAccessToken();
    var response = await http.get(
      Uri.parse(
          '$url/api/trade/history/sell/complete?lastTradeId=$lastTradeId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      },
    );
    if (response.statusCode == 200) {
      // print(response.body);
      List<dynamic> body = json.decode(response.body);
      trade = body.map((trades) => TradeDto.fromJson(trades)).toList();
      // print(trade);
    }
    return trade;
  }

  // 거래 상세 조회
  Future<TradeDto> getTradeDetail(int tradeId) async {
    final accessToken = await getJwtAccessToken();
    var response = await http.get(
      Uri.parse('$url/api/trade/detail/$tradeId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      },
    );
    if (response.statusCode == 200) {
      // print(response.body);
      return TradeDto.fromJson(
          json.decode(utf8.decode(response.bodyBytes))['data']);
    } else {
      print(response.statusCode);
      throw Exception("Error");
    }
  }

  // 거래 글 생성
  Future<void> postTrade(TradeDto tradeDto) async {
    final accessToken = await getJwtAccessToken();
    String jsonData = jsonEncode({
      "title": tradeDto.title,
      "description": tradeDto.description,
      "thumbnailImageUrl": tradeDto.thumbnailImageUrl,
      "countryCode": tradeDto.countryCode,
      "foreignCurrencyAmount": tradeDto.foreignCurrencyAmount,
      "koreanWonAmount": tradeDto.koreanWonAmount,
      "latitude": tradeDto.latitude,
      "longitude": tradeDto.longitude,
      "country": tradeDto.country,
      "administrativeArea": tradeDto.administrativeArea,
      "subAdministrativeArea": tradeDto.subAdministrativeArea,
      "locality": tradeDto.locality,
      "subLocality": tradeDto.subLocality,
      "thoroughfare": tradeDto.thoroughfare,
      "imageUrlList": tradeDto.imageUrlList
    });
    try {
      http.Response response = await http.post(Uri.parse('$url/api/trade/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization' : 'Bearer ${accessToken}',
          },
          body: jsonData);
      if(response.statusCode == 200) {
        print("SUCCESS!");
        String responseBody = utf8.decode(response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);
        // myUserId
        String sellerId = "1";
        DatabaseMethods().setDefaultTradeInfo(sellerId, data['id'].toString());
      }
    } catch (e) {
      print('등록 실패: $e');
    }
  }

  // 거래 글 수정
  Future<void> modifyTrade(TradeDto tradeDto) async {
    final accessToken = await getJwtAccessToken();
    String jsonData = jsonEncode({
      "title": tradeDto.title,
      "description": tradeDto.description,
      "thumbnailImageUrl": tradeDto.thumbnailImageUrl,
      "countryCode": tradeDto.countryCode,
      "foreignCurrencyAmount": tradeDto.foreignCurrencyAmount,
      "koreanWonAmount": tradeDto.koreanWonAmount,
      "latitude": tradeDto.latitude,
      "longitude": tradeDto.longitude,
      "country": tradeDto.country,
      "administrativeArea": tradeDto.administrativeArea,
      "subAdministrativeArea": tradeDto.subAdministrativeArea,
      "locality": tradeDto.locality,
      "subLocality": tradeDto.subLocality,
      "thoroughfare": tradeDto.thoroughfare,
      "imageUrlList": tradeDto.imageUrlList
    });
    try {
      http.Response response = await http.put(Uri.parse('$url/api/trade/edit/${tradeDto.id}'),
          headers: {
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Authorization": "Bearer ${accessToken}"
          },
          body: jsonData);
      if(response.statusCode == 200) {
        print("Modify Success");
      }
    } catch (e) {
      print('수정 실패: $e');
    }
  }

  // 거래 글 삭제
  Future<void> deleteTrade(int tradeId) async {
    final accessToken = await getJwtAccessToken();
    final response = await http.put(
      Uri.parse('$url/api/trade/delete/$tradeId'),
      headers: {
        "Authorization": "Bearer ${accessToken}"
      },
    );
  }

  Future<void> likeTrade(int tradeId) async {
    final accessToken = await getJwtAccessToken();

    final response = await http.post(
      Uri.parse('$url/api/trade/$tradeId/like'),
      headers: {
        "Authorization": "Bearer ${accessToken}"
      }
    );
  }

  Future<void> unlikeTrade(int tradeId) async {
    final accessToken = await getJwtAccessToken();
    final response = await http.delete(
      Uri.parse('$url/api/trade/$tradeId/unlike?memberId=1'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      }
    );
  }

  // 채팅방 내 거래글 정보 가져오기
  Future<Map<String, dynamic>> getChatTransactionInfo(
      String? sellerId, String? tradeId) async {
    final accessToken = await getJwtAccessToken();
    print('sellerId: $sellerId, tradeId: $tradeId');
    try {
      http.Response _response = await http.get(Uri.parse(
          "https://j9a705.p.ssafy.io/api/trade/chat/${tradeId}"),headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${accessToken}',
      },);
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

  // 직거래 약속 잡기
  Future<void> setDirectAppointment(
      Map<String, dynamic> apptInfoMap, String tradeId, String memberId) async {
    final accessToken = await getJwtAccessToken();
    print('tradeId: $tradeId');
    final String jsonData = json.encode(apptInfoMap);
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/direct/${tradeId}"),
        body: jsonData,
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer ${accessToken}',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);
      } else {
        print('상태 코드 오류: ${_response.statusCode}');
      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }

  // 택배거래 약속 잡기
  Future<void>  setDeliveryAppointment(
      Map<String, dynamic> apptInfoMap, String tradeId, String memberId) async {
    final accessToken = await getJwtAccessToken();
    print('tradeId: $tradeId');
    final String jsonData = json.encode(apptInfoMap);
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/delivery/${tradeId}"),
        body: jsonData,
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer ${accessToken}',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print("ResponseBody : $responseBody");
      } else {
        print('상태 코드 오류: ${_response.statusCode}');

      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }

  // 거래 완료
  Future<void> setCompleteAppointment(String tradeId, String memberId) async {
    final accessToken = await getJwtAccessToken();
    print('tradeId: $tradeId');
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/complete/${tradeId}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer ${accessToken}',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);

      } else {
        print('상태 코드 오류: ${_response.statusCode}');

      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }

  // 약속 취소
  Future<void> cancelAppointment(String tradeId, String memberId) async {
    final accessToken = await getJwtAccessToken();
    print('tradeId: $tradeId');
    try {
      http.Response _response = await http.put(
        Uri.parse(
            "https://j9a705.p.ssafy.io/api/trade/promise/cancel/${tradeId}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : 'Bearer ${accessToken}',
        },
      );
      if (_response.statusCode == 200) {
        String responseBody = utf8.decode(_response.bodyBytes); // utf-8로 변환
        Map<String, dynamic> jsonData = json.decode(responseBody);
        // "data" 객체 추출
        Map<String, dynamic> data = jsonData['data'];
        print(responseBody);

      } else {
        print('상태 코드 오류: ${_response.statusCode}');

      }
    } catch (e) {
      print('조회 실패: $e');
    }
  }
}
