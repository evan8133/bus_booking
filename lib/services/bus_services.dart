import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/bus.dart';

class BusService {
  final CollectionReference busesCollection =
      FirebaseFirestore.instance.collection('buses');

  Future<void> addBus(Bus bus) {
    return busesCollection.doc(bus.busId).set(bus.toJson());
  }

  Future<void> deleteBus(String busId) {
    return busesCollection.doc(busId).delete();
  }

  Future<Bus?> getBusById(String busId) async {
    DocumentSnapshot snapshot = await busesCollection.doc(busId).get();
    if (snapshot.exists) {
      return Bus.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<Bus>> getAllBuses() async {
    QuerySnapshot snapshot = await busesCollection.get();
    List<Bus> buses = snapshot.docs
        .map((doc) => Bus.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return buses;
  }
}
