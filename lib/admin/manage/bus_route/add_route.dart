import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/services/route_services.dart';
import 'package:bus_booking/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../models/geolocation.dart';
import '../../../models/route.dart' as MyRoute;
import '../../../utils/button.dart';
import '../../../utils/input_box.dart';

class AddRouteScreen extends StatefulWidget {
  const AddRouteScreen({Key? key}) : super(key: key);

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  List<Geolocation> _stops = [];
  bool isLoading = false;

  Set<Marker> _markers = {};
  List<LatLng> _polylinePoints = [];
  LatLng _selectedLocation = LatLng(0, 0);
  LatLng _currentLocation = LatLng(0, 0);
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
      _selectedLocation = _currentLocation;
    });
  }

  void _addStop(Geolocation stop) {
    setState(() {
      _stops.add(stop);
      _updateMarkersAndRoute();
    });
  }

  void _removeStop(Geolocation stop) {
    setState(() {
      _stops.remove(stop);
      _updateMarkersAndRoute();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // Create the route object
      MyRoute.Route route = MyRoute.Route(
        name: _nameController.text,
        start: _startController.text,
        end: _endController.text,
        stops: _stops,
      );
      context.read<RouteService>().addRoute(route).then((value) {
        showSnackBar(context, 'Route has been added');
        context.router.pop();
      });
      // Clear the form
      _formKey.currentState!.reset();
      _nameController.clear();
      _startController.clear();
      _endController.clear();
      setState(() {
        _stops.clear();
        _markers.clear();
        _polylinePoints.clear();
      });

      // Show a success message or navigate to a new screen
    }
  }

  @override
  void dispose() {
    super.dispose();
    _endController.dispose();
    _nameController.dispose();
    _endController.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedLocation = tappedPoint;
      _updateMarkersAndRoute();
    });
  }

  Future<void> _updateMarkersAndRoute() async {
    _markers.clear();
    _polylinePoints.clear();

    // Add start marker
    if (_stops.isNotEmpty) {
      _markers.add(
        Marker(
          markerId: const MarkerId('startLocation'),
          position: _stops.first.toLatLng(),
        ),
      );
    }

    // Add stop markers
    _markers.addAll(
      _stops.map(
        (stop) => Marker(
          markerId: MarkerId(stop.toString()),
          position: stop.toLatLng(),
        ),
      ),
    );

    // Generate route between stops
    if (_stops.length >= 2) {
      List<LatLng> routePoints = await _generateRoutePoints();
      _polylinePoints.addAll(routePoints);
    }

    setState(() {});
  }

  Future<List<LatLng>> _generateRoutePoints() async {
    List<LatLng> routePoints = [];

    String apiKey = 'AIzaSyAjaGWBMTQuFityWuHRB5lokimKetelTEE'; // Replace with your Google Maps Directions API key
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

    for (int i = 0; i < _stops.length - 1; i++) {
      Geolocation start = _stops[i];
      Geolocation end = _stops[i + 1];

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
            List<LatLng> decodedPoints = decodePolyline(polylinePoints);
            routePoints.addAll(decodedPoints);
          }
        }
      }
    }

    return routePoints;
  }

  List<LatLng> decodePolyline(String encoded) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              MyTextField(
                controller: _nameController,
                labelText: 'Route Name',
                hintText: 'Enter route name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for the route';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _startController,
                labelText: 'Starting Point',
                hintText: 'Enter starting point',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the starting point';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _endController,
                labelText: 'Ending Point',
                hintText: 'Enter ending point',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the ending point';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Stops',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stops.length,
                itemBuilder: (context, index) {
                  Geolocation stop = _stops[index];
                  return ListTile(
                    title: Text(
                      'Stop ${index + 1}: (${stop.latitude}, ${stop.longitude})',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeStop(stop),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Select Location'),
                        content: SizedBox(
                          height: 200,
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _currentLocation,
                              zoom: 15.0,
                            ),
                            markers: _markers,
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId('route'),
                                points: _polylinePoints,
                                color: Colors.blue,
                                width: 3,
                              ),
                            },
                            onTap: _handleMapTap,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _addStop(Geolocation(
                                latitude: _selectedLocation.latitude,
                                longitude: _selectedLocation.longitude,
                              ));
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Stop'),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              MyButton(
                onPressed: _submitForm,
                text: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
