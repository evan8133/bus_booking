import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../../models/route.dart' as MyRoute;
import '../../../../../models/geolocation.dart';

class ViewRouteInfoScreen extends StatefulWidget {
  final MyRoute.Route route;

  const ViewRouteInfoScreen({Key? key, required this.route}) : super(key: key);

  @override
  _ViewRouteInfoScreenState createState() => _ViewRouteInfoScreenState();
}

class _ViewRouteInfoScreenState extends State<ViewRouteInfoScreen> {
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _fetchDirections();
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: LatLng(
          widget.route.stops.first.latitude,
          widget.route.stops.first.longitude,
        ),
        infoWindow: const InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: LatLng(
          widget.route.stops.last.latitude,
          widget.route.stops.last.longitude,
        ),
        infoWindow: const InfoWindow(title: 'End'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    for (int i = 1; i < widget.route.stops.length - 1; i++) {
      Geolocation stop = widget.route.stops[i];
      _markers.add(
        Marker(
          markerId: MarkerId('stop_$i'),
          position: LatLng(stop.latitude, stop.longitude),
          infoWindow: InfoWindow(title: 'Stop $i'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }
  }

  Future<void> _fetchDirections() async {
    List<LatLng> polylineCoordinates = [];

    for (int i = 0; i < widget.route.stops.length - 1; i++) {
      Geolocation start = widget.route.stops[i];
      Geolocation end = widget.route.stops[i + 1];

      String apiKey =
          'AIzaSyAjaGWBMTQuFityWuHRB5lokimKetelTEE'; // Replace with your Google Maps Directions API key
      String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

      String url =
          '$baseUrl?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> routes = responseData['routes'];

        if (routes.isNotEmpty) {
          List<dynamic> legs = routes[0]['legs'];
          List<dynamic> steps = legs[0]['steps'];

          for (dynamic step in steps) {
            String polylinePoints = step['polyline']['points'];
            List<LatLng> decodedPoints = _decodePolyline(polylinePoints);
            polylineCoordinates.addAll(decodedPoints);
          }
        }
      }
    }

    setState(() {
      _polylineCoordinates = polylineCoordinates;

      _routePolyline = Polyline(
        polylineId: const PolylineId('route_polyline'),
        points: _polylineCoordinates,
        color: Colors.blue,
        width: 3,
      );
    });
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyPoints = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng((lat / 1e5), (lng / 1e5));
      polyPoints.add(point);
    }

    return polyPoints;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.route.stops.first.latitude,
                  widget.route.stops.first.longitude,
                ),
                zoom: 15.0,
              ),
              markers: _markers,
              polylines: _routePolyline != null ? {_routePolyline!} : {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route Name: ${widget.route.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Starting Point: ${widget.route.start}',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ending Point: ${widget.route.end}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
