import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  LatLng currentPosition = const LatLng(37.5013068, 127.0396597);

  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '장소 선택',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(children: [
          SizedBox(
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(height: 150, color: Colors.red),
                SizedBox(
                  height: 500,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      setState(() {
                        mapController = controller;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentPosition,
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
            bottom: 250,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: SizedBox(
              width: 50,
              child: Image.asset("assets/images/marker.png"),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
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
          )
        ]),
      ),
    );
  }
}
