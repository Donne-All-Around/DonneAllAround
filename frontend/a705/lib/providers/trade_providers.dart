import 'dart:convert';

import 'package:a705/models/TradeDto.dart';
import 'package:http/http.dart' as http;

class TradeProviders {
  String url = "https://j9a705.p.ssafy.io";

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
    List<TradeDto> trade = [];

    final response = await http.post(
      lastTradeId == null
          ? Uri.parse('$url/api/trade/list?lastTradeId=&sort=createTime')
          : Uri.parse(
              '$url/api/trade/list?lastTradeId=$lastTradeId&sort=createTime'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
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
      // print(response.statusCode);
      // List<dynamic> body = json.decode(response.body)['data']['tradeList']; // 한글 깨짐
      List<dynamic> body =
          json.decode(utf8.decode(response.bodyBytes))['data']['tradeList'];
      trade = body.map((trades) => TradeDto.fromJson(trades)).toList();
      // print(trade);
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

    final response = await http.post(
      lastTradeId == null
          ? Uri.parse('$url/api/trade/list?lastTradeId=&sort=koreanWonAmount')
          : Uri.parse(
              '$url/api/trade/list?lastTradeId=$lastTradeId&sort=koreanWonAmount'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
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

    final response = await http.post(
      lastTradeId == null
          ? Uri.parse(
              '$url/api/trade/list?lastTradeId=&sort=koreanWonPerForeignCurrency')
          : Uri.parse(
              '$url/api/trade/list?lastTradeId=$lastTradeId&sort=koreanWonPerForeignCurrency'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
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
    var response = await http.get(
      Uri.parse(
          '$url/api/trade/history/sell/complete?lastTradeId=$lastTradeId?memberId=1'),
      headers: <String, String>{
        'Content-Type': 'applcation/json',
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
    var response = await http.get(
      Uri.parse('$url/api/trade/detail/$tradeId?memberId=1'),
      headers: <String, String>{
        'Content-Type': 'applcation/json',
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
      http.Response response = await http.post(Uri.parse('$url/api/trade/create?memberId=1'),
          headers: {
            "Accept": "application/json",
            "Content-Type":"application/json"
          },
          body: jsonData);
      if(response.statusCode == 200) {
        print("SUCCESS!");
      }
    } catch (e) {
      print('등록 실패: $e');
    }
  }

  Future<void> likeTrade(int tradeId) async {
    final response = await http.post(
      Uri.parse('$url/api/trade/$tradeId/like?memberId=1'),
    );

    print(response.statusCode);
  }

  Future<void> unlikeTrade(int tradeId) async {
    final response = await http.delete(
      Uri.parse('$url/api/trade/$tradeId/unlike?memberId=1'),
    );

    print(response.statusCode);
  }
}
