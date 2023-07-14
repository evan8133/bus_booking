import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/route.dart';

class RouteService {
  final CollectionReference routesCollection =
      FirebaseFirestore.instance.collection('routes');

  Future<void> addRoute(Route route) {
    return routesCollection.doc(route.routeId).set(route.toJson());
  }

  Future<void> deleteRoute(String routeId) {
    return routesCollection.doc(routeId).delete();
  }

  Future<Route?> getRouteById(String routeId) async {
    DocumentSnapshot snapshot = await routesCollection.doc(routeId).get();
    if (snapshot.exists) {
      return Route.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<Route>> getAllRoutes() async {
    QuerySnapshot snapshot = await routesCollection.get();
    List<Route> routes = snapshot.docs
        .map((doc) => Route.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return routes;
  }

  Future<void> updateStops(String routeId, List<Geolocation> stops) {
    return routesCollection.doc(routeId).update({'stops': stops});
  }
}
