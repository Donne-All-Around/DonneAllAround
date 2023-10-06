import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:a705/models/ExchangeDto.dart';

import '../models/DateRateDto.dart';

class ExchangeRateProvider {
  final String baseUrl = 'http://api.currencylayer.com/live';
  final String accessKey = '801421925fd59c4a9b9fb2fa00a51d2c';
  // final String accessKey = '528ac9fb6c6fa1c649da1db532cf09e7';
  // final String accessKey = '';
  final String currencies = 'KRW,JPY,AUD,CAD,CNY,CZK,EUR,GBP,HKD,NZD,PHP,RUB,SGD,TWD,VND';
  final String date = '2023-10-05';

  Future<ExchangeRateResponse> fetchCurrencyData() async {
    final String url = '$baseUrl?access_key=$accessKey&currencies=$currencies&source=USD&format=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ExchangeRateResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<double>> fetchDateData(String date) async {
    final String url = '$baseUrl?access_key=$accessKey&date=$date&currencies=$currencies&format=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final Map<String, dynamic> quotesMap = jsonResponse['quotes'];

        final List<double> exchangeRates = [
          quotesMap['USDKRW'].toDouble(),
          quotesMap['USDJPY'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
          quotesMap['USDEUR'].toDouble(),
          quotesMap['USDGBP'].toDouble(),
          quotesMap['USDAUD'].toDouble(),
          quotesMap['USDCAD'].toDouble(),
          quotesMap['USDHKD'].toDouble(),
          quotesMap['USDPHP'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
          quotesMap['USDCNY'].toDouble(),
        ];

        return exchangeRates;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
