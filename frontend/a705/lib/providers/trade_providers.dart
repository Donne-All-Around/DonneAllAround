import 'dart:convert';

import 'package:a705/models/TradeDto.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class TradeProviders {
  Dio dio = Dio();
  String url = "https://j9a705.p.ssafy.io";

  // 거래 목록 조회(최신순)
  Future<List<TradeDto>> getLatestTrade(
      String countryCode,
      int lastTradeId,
      String preferredTradeCountry,
      String preferredTradeCity,
      String preferredTradeDistrict,
      String preferredTradeTown) async {
    List<TradeDto> trade = [];

    final response = await http.post(
      Uri.parse('$url/api/trade/list?sort=createTime'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode({
        "countryCode": countryCode,
        "lastTradeId": lastTradeId,
        "preferredTradeCountry": preferredTradeCountry,
        "preferredTradeCity": preferredTradeCity,
        "preferredTradeDistrict": preferredTradeDistrict,
        "preferredTradeTown": preferredTradeTown,
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
      int lastTradeId,
      String preferredTradeCountry,
      String preferredTradeCity,
      String preferredTradeDistrict,
      String preferredTradeTown) async {
    List<TradeDto> trade = [];

    final response = await http.post(
      Uri.parse('$url/api/trade/list?sort=koreanWonAmount'),
      body: jsonEncode({
        'countryCode': countryCode,
        'lastTradeId': lastTradeId,
        'preferredTradeCountry': preferredTradeCountry,
        'preferredTradeCity': preferredTradeCity,
        'preferredTradeDistrict': preferredTradeDistrict,
        'preferredTradeTown': preferredTradeTown,
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
      int lastTradeId,
      String preferredTradeCountry,
      String preferredTradeCity,
      String preferredTradeDistrict,
      String preferredTradeTown) async {
    List<TradeDto> trade = [];

    final response = await http.post(
      Uri.parse('$url/api/trade/list?sort=koreanWonPerForeignCurrency'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode({
        'countryCode': countryCode,
        'lastTradeId': lastTradeId,
        'preferredTradeCountry': preferredTradeCountry,
        'preferredTradeCity': preferredTradeCity,
        'preferredTradeDistrict': preferredTradeDistrict,
        'preferredTradeTown': preferredTradeTown,
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
          '$url/api/trade/history/sell/complete?lastTradeId=$lastTradeId'),
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
      Uri.parse('$url/api/trade/detail/$tradeId'),
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
  Future<String> postTrade(TradeDto tradeDto) async {
    // var response = await http.post(
    //   Uri.parse('$url/api/trade/create'),
    //   headers: {'Content-Type': 'applcation/json'},
    //   body: tradeDto.toJson(),
    // );
    Response response = await dio.post(
      '$url/',
      data: tradeDto.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'}, // Content-Type 설정
      ),
    );

    print(response.data);
    print(response.statusCode);

    return response.data;
  }
}
