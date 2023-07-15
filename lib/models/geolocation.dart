import 'package:google_maps_flutter/google_maps_flutter.dart';

class Geolocation {
  double latitude;
  double longitude;

  Geolocation({
    required this.latitude,
    required this.longitude,
  });

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    return Geolocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}