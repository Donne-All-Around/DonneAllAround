import 'dart:convert';

import 'package:a705/models/TradeDto.dart';
import 'package:http/http.dart' as http;

class TradeProviders {

  String url = "https://j9a705.p.ssafy.io";

  Future<List<TradeDto>> getLatestTrade(String countryCode, int lastTradeId, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown) async {
    List<TradeDto> trade = [];

    final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'countryCode': countryCode,
          'lastTradeId': lastTradeId,
          'preferredTradeCountry': preferredTradeCountry,
          'preferredTradeCity': preferredTradeCity,
          'preferredTradeDistrict': preferredTradeDistrict,
          'preferredTradeTown': preferredTradeTown,
        }),
    );
    // if (response.statusCode == 200) {
    //   print(response.body);
    //   trade = response.body['tradeList'].map<TradeDto>((trades) {
    //     return TradeDto.fromJson(trades);
    //   }).toList();
    //   print(trade);
    // }

    return trade;
  }

  Future<String> postTrade(TradeDto tradeDto) async {
    var response = await http.post(
      Uri.parse('${url}api/trade/create'),
      headers: <String, String>{
        'Content-Type': 'applcation/json',
      },
      body: tradeDto.toJson(),
    );
    return response.body;
  }
}