import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:a705/models/ExchangeDto.dart';

class ExchangeRateProvider {
  final String baseUrl = 'http://api.currencylayer.com/live';
  final String accessKey = '801421925fd59c4a9b9fb2fa00a51d2c';
  final String currencies = 'KRW,JPY,AUD,CAD,CNY,CZK,EUR,GBP,HKD,NZD,PHP,RUB,SGD,TWD,VND';

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
}

void main() {
  final exchangeProvider = ExchangeRateProvider();
  exchangeProvider.fetchCurrencyData(); // API 데이터 가져오기
}
