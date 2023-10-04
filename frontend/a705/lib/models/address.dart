class Address {
  final String? country;
  final String? administrativeArea;
  final String? subAdministrativeArea;
  final String? locality;
  final String? subLocality;
  final String? thoroughfare;
  final double latitude;
  final double longitude;

  Address({
    required this.country,
    required this.administrativeArea,
    required this.subAdministrativeArea,
    required this.locality,
    required this.subLocality,
    required this.thoroughfare,
    required this.latitude,
    required this.longitude,
  });
}
