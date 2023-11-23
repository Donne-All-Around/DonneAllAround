import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:a705/models/ExchangeDto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExchangeRateProvider {
  final String? baseUrl = dotenv.env['bank_api'];
  final String? accessKey = dotenv.env['accessKey'];
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

  Future<ExchangeRateResponse> fetchDateData(String date) async {
    final String url = '$baseUrl?access_key=$accessKey&date=$date&currencies=$currencies&format=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = json.decode(jsonResponse);
        return ExchangeRateResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
