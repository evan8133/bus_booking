import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/models/booking.dart';
import 'package:bus_booking/models/geolocation.dart';
import 'package:bus_booking/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:bus_booking/models/schedule.dart';
import 'package:bus_booking/models/bus.dart';
import 'package:bus_booking/models/route.dart' as MyRoute;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';
import '../../services/users_services.dart';

class ViewScheduleRoutesScreen extends StatefulWidget {
  final Schedule schedule;
  final Bus bus;
  final MyRoute.Route route;

  ViewScheduleRoutesScreen({
    Key? key,
    required this.schedule,
    required this.bus,
    required this.route,
  }) : super(key: key);

  @override
  _ViewScheduleRoutesScreenState createState() =>
      _ViewScheduleRoutesScreenState();
}

class _ViewScheduleRoutesScreenState extends State<ViewScheduleRoutesScreen> {
  final Set<Marker> _markers = {};
  LatLng? currentLocation;
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _addMarkers();
    _fetchDirections();
  }

  void getCurrentLocation() async {
    var locationData = await Location().getLocation();
    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      _markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          markerId: const MarkerId('current_location'),
          position: currentLocation!,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    });
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
            BitmapDescriptor.hueViolet,
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

  void _onMapCreated(GoogleMapController controller) {}

  @override
  @override
  Widget build(BuildContext context) {
    var user = context.read<FirebsaeAuthMethods>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Route Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: currentLocation!,
                      zoom: 14.0,
                    ),
                    markers: _markers,
                    polylines: _routePolyline != null ? {_routePolyline!} : {},
                  ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.directions_bus),
                            title: const Text('Bus Details'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Model: ${widget.bus.model}'),
                                Text(
                                    'Registration Number: ${widget.bus.registrationNumber}'),
                                Text('Capacity: ${widget.bus.capacity}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.route),
                            title: const Text('Route Details'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Name: ${widget.route.name}'),
                                Text('Start: ${widget.route.start}'),
                                Text('End: ${widget.route.end}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.schedule),
                            title: const Text('Schedule Details'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Departure Times:'),
                                ...widget.schedule.departureTimes
                                    .map((time) =>
                                        Text(DateFormat('jm').format(time)))
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Book This Schedule'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Are you sure you want to book this schedule?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () {
                                  Booking book = Booking(
                                    userId: user.uid,
                                    scheduleId: widget.schedule.scheduleId,
                                    date:
                                        DateTime.now().toIso8601String(),
                                    numberOfPersons: 1,
                                  );
                                  context
                                      .read<UserService>()
                                      .bookSchedule(
                                          user.uid, book)
                                      .then((value) {
                                    showSnackBar(context,
                                        'Schedule booked successfully!');
                                    context.router.pop();
                                    //error handling
                                  }).catchError((error) {
                                    showSnackBar(context, error.toString());
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
