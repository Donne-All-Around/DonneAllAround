import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class SearchAddressPage extends StatefulWidget {
  const SearchAddressPage({super.key});

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소 검색'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      useLocalServer: true,
                      localPort: 1024,
                      kakaoKey: '0c75e0af40aaa0554ca69939967756ed',
                      callback: (Kpostal result) {
                        setState(() {
                          postCode = result.postCode;
                          address = result.address;
                          latitude = result.latitude.toString();
                          longitude = result.longitude.toString();
                          kakaoLatitude = result.kakaoLatitude.toString();
                          kakaoLongitude =
                              result.kakaoLongitude.toString();
                        });
                      },
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue)),
              child: const Text(
                'Search Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text('postCode',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: $postCode'),
                  const Text('address',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: $address'),
                  const Text('LatLng', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: $latitude / longitude: $longitude'),
                  const Text('through KAKAO Geocoder',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: $kakaoLatitude / longitude: $kakaoLongitude'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}