import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/models/route.dart' as MyRoute;
import 'package:bus_booking/services/driver_services.dart';
import 'package:bus_booking/services/route_services.dart';
import 'package:bus_booking/services/schedule_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/bus.dart';
import '../models/driver.dart';
import '../models/geolocation.dart';
import '../models/schedule.dart';

class DriverViewScreen extends StatefulWidget {
  final Driver driver;

  DriverViewScreen({Key? key, required this.driver}) : super(key: key);

  @override
  _DriverViewScreenState createState() => _DriverViewScreenState();
}

class _DriverViewScreenState extends State<DriverViewScreen> {
  bool firstLoad = true;
  StreamSubscription? _locationSubscription;
  final Set<Marker> _markers = {};
  LatLng? currentLocation;
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;

  void _addMarkers(MyRoute.Route route) {
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: LatLng(
          route.stops.first.latitude,
          route.stops.first.longitude,
        ),
        infoWindow: const InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: LatLng(
          route.stops.last.latitude,
          route.stops.last.longitude,
        ),
        infoWindow: const InfoWindow(title: 'End'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    for (int i = 1; i < route.stops.length - 1; i++) {
      Geolocation stop = route.stops[i];
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

  Future<void> _fetchDirections(MyRoute.Route route) async {
    List<LatLng> polylineCoordinates = [];

    for (int i = 0; i < route.stops.length - 1; i++) {
      Geolocation start = route.stops[i];
      Geolocation end = route.stops[i + 1];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Driver View'),
        actions: [
          IconButton(
            onPressed: () {
              context.router.replace(const LoginRoute());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.drive_eta),
              title: Text('Driver Name: ${widget.driver.name}'),
              subtitle: Text('License Number: ${widget.driver.licenseNumber}'),
            ),
          ),
          FutureBuilder(
            future: context
                .read<DriverService>()
                .getBusByDriverId(widget.driver.driverId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                Bus bus = snapshot.data!;
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.directions_bus),
                        title: Text('Bus Number: ${bus.registrationNumber}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bus Model: ${bus.model}'),
                            Text('Bus Capacity: ${bus.capacity.toString()}'),
                          ],
                        ),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future:
                            context.read<ScheduleService>().getScheduleByBusId(
                                  bus.busId,
                                ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.hasData) {
                            Schedule schedule = snapshot.data!;
                            return Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.schedule),
                                  title: const Text('Schedule Times'),
                                  subtitle: Text(
                                      'Departure Times: ${schedule.departureTimes.map((dt) => DateFormat('hh:mm').format(dt)).join(', ')}'),
                                ),
                                FutureBuilder(
                                  future: context
                                      .read<RouteService>()
                                      .getRouteById(schedule.routeId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    if (snapshot.hasData) {
                                      MyRoute.Route route = snapshot.data!;
                                      if (firstLoad) {
                                        _addMarkers(route);
                                        _fetchDirections(route);
                                        firstLoad = false;
                                      }
                                      return Card(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading:
                                                  const Icon(Icons.location_on),
                                              title: Text(
                                                  'Route Name: ${route.name}'),
                                              subtitle: Text(
                                                  'Route Start: ${route.start}\nRoute End: ${route.end}'),
                                            ),
                                            SizedBox(
                                              height: 300,
                                              child: GoogleMap(
                                                onMapCreated: _onMapCreated,
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target:
                                                      _markers.first.position,
                                                  zoom: 12,
                                                ),
                                                markers: _markers,
                                                polylines:
                                                    _routePolyline != null
                                                        ? {_routePolyline!}
                                                        : {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const Center(
                                        child: Text('No route assigned'));
                                  },
                                ),
                              ],
                            );
                          }
                          return const Center(
                              child: Text('No schedule assigned'));
                        },
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('No bus assigned'));
            },
          ),
        ],
      ),
    );
  }
}
