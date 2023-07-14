import 'package:uuid/uuid.dart';

class Route {
  String routeId;
  String name;
  String start;
  String end;
  List<Geolocation> stops;

  Route({
    String? routeId,
    required this.name,
    required this.start,
    required this.end,
    required this.stops,
  }) : routeId = routeId ?? Uuid().v4();

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeId: json['routeId'],
      name: json['name'],
      start: json['start'],
      end: json['end'],
      stops: (json['stops'] as List<dynamic>)
          .map((stop) => Geolocation.fromJson(stop))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'name': name,
      'start': start,
      'end': end,
      'stops': stops.map((stop) => stop.toJson()).toList(),
    };
  }
}


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
}