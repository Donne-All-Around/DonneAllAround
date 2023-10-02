import 'dart:async';
import 'package:a705/models/address.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseLocationPage2 extends StatefulWidget {
  final double lat;
  final double lng;

  const ChooseLocationPage2(this.lat, this.lng, {super.key});

  @override
  State<ChooseLocationPage2> createState() => _ChooseLocationPage2State();
}

class _ChooseLocationPage2State extends State<ChooseLocationPage2> {
  late LatLng currentPosition = LatLng(widget.lat, widget.lng);

  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }

  double latitude = 37.5013068;
  double longitude = 127.0396597;

  final myController = TextEditingController();

  String addr = "";
  Address address = Address(country: "", city: "", district: "", town: "");

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              '장소 선택',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.check_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  if(addr.isNotEmpty) {
                    Navigator.pop(context, address);
                  }
                },
              ),
            ],
          ),
          body: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height / 3 * 1,
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  const Text(
                    '거래하실 장소를 선택해 주세요.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Center(child: Text('선택하신 장소')),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black87),
                    ),
                    child: Center(
                      child: Text(
                        addr,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3 * 2,
                    child: GoogleMap(
                      onCameraMove: (object) => {
                        setState(() {
                          currentPosition = object.target;
                          latitude = object.target.latitude;
                          longitude = object.target.longitude;
                        })
                      },
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        setState(() {
                          mapController = controller;
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.lat, widget.lng),
                        zoom: 17,
                      ),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              // alignment: Alignment.center,
              bottom: MediaQuery.of(context).size.height / 3 * 1,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: SizedBox(
                width: 50,
                child: Image.asset("assets/images/marker.png"),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 30,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () async {
                  var gps = await getCurrentLocation();
                  mapController?.animateCamera(CameraUpdate.newLatLng(
                      LatLng(gps.latitude, gps.longitude)));
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black87,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: GestureDetector(
                onTap: () async {
                  LatLng _currentCenter = await getCenter();
                  List<Placemark> placemark = await placemarkFromCoordinates(
                      _currentCenter.latitude, _currentCenter.longitude, localeIdentifier: "ko");

                  String addressssss ='${placemark.first.thoroughfare!.isNotEmpty ? '${placemark.first.thoroughfare}, ' : ''}${placemark.first.subLocality!.isNotEmpty ? '${placemark.first.subLocality}, ' : ''}${placemark.first.locality!.isNotEmpty ? '${placemark.first.locality}, ' : ''}${placemark.first.subAdministrativeArea!.isNotEmpty ? '${placemark.first.subAdministrativeArea}, ' : ''}${placemark.first.administrativeArea!.isNotEmpty ? placemark.first.administrativeArea : ''}';


                  print(addressssss);

                  // print('country: ${placemark.reversed.last.country}');
                  // print('locality: ${placemark.reversed.last.locality}');
                  // print('street: ${placemark.reversed.last.street}');
                  // print('subLocality: ${placemark.reversed.last.subLocality}');
                  // print('name: ${placemark.reversed.last.name}');
                  // print(
                  //     'isoCountryCode: ${placemark.reversed.last.isoCountryCode}');
                  // print('postalCode: ${placemark.reversed.last.postalCode}');
                  // print(
                  //     'administrativeArea: ${placemark.reversed.last.administrativeArea}');
                  // print(
                  //     'subAdministrativeArea: ${placemark.reversed.last.subAdministrativeArea}');
                  // print(
                  //     'subThoroughfare: ${placemark.reversed.last.subThoroughfare}');
                  // print('thoroughfare: ${placemark.reversed.last.thoroughfare}');
                  // print('hashCode: ${placemark.reversed.last.hashCode}');

                  setState(() {
                    address = Address(country: placemark.reversed.last.country!,
                    city: placemark.reversed.last.administrativeArea!,
                    district: placemark.reversed.last.subLocality!,
                    town: placemark.reversed.last.thoroughfare!);

                    addr = addressssss;
                    // addr =
                    //     "${placemark.reversed.last.subLocality} ${placemark.reversed.last.thoroughfare}";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD954),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      '선택하기',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
