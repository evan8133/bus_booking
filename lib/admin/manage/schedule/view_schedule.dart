import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/bus.dart';
import '../../../models/driver.dart';
import '../../../models/route.dart' as MyRoute;
import '../../../models/schedule.dart';
import '../../../services/bus_services.dart';
import '../../../services/driver_services.dart';
import '../../../services/route_services.dart';
import '../../../models/geolocation.dart';

class ViewScheduleScreen extends StatefulWidget {
  final Schedule schedule;

  const ViewScheduleScreen({Key? key, required this.schedule})
      : super(key: key);

  @override
  _ViewScheduleScreenState createState() => _ViewScheduleScreenState();
}

class _ViewScheduleScreenState extends State<ViewScheduleScreen> {
  late Future<Bus?> _busFuture;
  late Future<MyRoute.Route?> _routeFuture;
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _busFuture = _fetchBus(widget.schedule.busId);
    _routeFuture = _fetchRoute(widget.schedule.routeId);
    _fetchDirections();
  }

  Future<Bus?> _fetchBus(String busId) {
    final busService = context.read<BusService>();
    return busService.getBusById(busId);
  }

  Future<MyRoute.Route?> _fetchRoute(String routeId) {
    final routeService = context.read<RouteService>();
    return routeService.getRouteById(routeId);
  }

  Future<void> _fetchDirections() async {
    MyRoute.Route? route = await _routeFuture;

    if (route == null) return;

    for (int i = 0; i < route.stops.length - 1; i++) {
      Geolocation start = route.stops[i];
      Geolocation end = route.stops[i + 1];

      String apiKey =
          'YOUR_API_KEY_HERE'; // Replace with your Google Maps Directions API key
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

    setState(() {});
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;
      LatLng point = LatLng(latitude, longitude);
      poly.add(point);
    }

    return poly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Schedule'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<Bus?>(
                    future: _busFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading Bus...');
                      }
                      if (snapshot.hasError) {
                        return const Text('Error loading Bus');
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Bus not found');
                      }
                      final bus = snapshot.data!;
                      return Column(
                        children: [
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.directions_bus),
                              title: const Text('Bus'),
                              subtitle: Text(
                                'Registration Number: ${bus.registrationNumber}\nModel: ${bus.model}\nCapacity: ${bus.capacity}',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<Driver?>(
                            future: context
                                .read<DriverService>()
                                .getDriverById(bus.driverId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Loading Driver...');
                              }
                              if (snapshot.hasError) {
                                return const Text('Error loading Driver');
                              }
                              if (!snapshot.hasData || snapshot.data == null) {
                                return const Text('Driver not found');
                              }
                              final driver = snapshot.data!;
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Driver'),
                                  subtitle: Text(
                                    'Name: ${driver.name}\nLicense Number: ${driver.licenseNumber}\nContact Info: ${driver.contactInfo}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<MyRoute.Route?>(
                    future: _routeFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading Route...');
                      }
                      if (snapshot.hasError) {
                        return const Text('Error loading Route');
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Route not found');
                      }
                      final route = snapshot.data!;
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.map),
                                title: const Text('Route'),
                                subtitle: Text(
                                  'Name: ${route.name}\nStart: ${route.start}\nEnd: ${route.end}',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: constraints.maxHeight -
                                    ScreenUtil().setHeight(400),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      route.stops.first.latitude,
                                      route.stops.first.longitude,
                                    ),
                                    zoom: 13,
                                  ),
                                  markers: <Marker>{
                                    Marker(
                                      markerId: const MarkerId('start'),
                                      position: LatLng(
                                        route.stops.first.latitude,
                                        route.stops.first.longitude,
                                      ),
                                      infoWindow:
                                          const InfoWindow(title: 'Start'),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              BitmapDescriptor.hueGreen),
                                    ),
                                    Marker(
                                      markerId: const MarkerId('end'),
                                      position: LatLng(
                                        route.stops.last.latitude,
                                        route.stops.last.longitude,
                                      ),
                                      infoWindow:
                                          const InfoWindow(title: 'End'),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              BitmapDescriptor.hueRed),
                                    ),
                                    ...route.stops
                                        .sublist(1, route.stops.length - 1)
                                        .map(
                                          (stop) => Marker(
                                            markerId: MarkerId(
                                                stop.latitude.toString() +
                                                    stop.longitude.toString()),
                                            position: LatLng(
                                              stop.latitude,
                                              stop.longitude,
                                            ),
                                            infoWindow:
                                                const InfoWindow(title: 'Stop'),
                                            icon: BitmapDescriptor
                                                .defaultMarkerWithHue(
                                                    BitmapDescriptor.hueBlue),
                                          ),
                                        ),
                                  },
                                  polylines: {
                                    Polyline(
                                      polylineId: const PolylineId('route'),
                                      points: polylineCoordinates,
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Schedule Times:',
                            style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.schedule.departureTimes.length,
                            itemBuilder: (context, index) {
                              DateTime dateTime =
                                  widget.schedule.departureTimes[index];
                              String time =
                                  '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                              return ListTile(
                                leading: const Icon(Icons.schedule),
                                title: Text(time),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
