import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus.dart';
import '../models/driver.dart';

class DriverService {
  final CollectionReference driversCollection =
      FirebaseFirestore.instance.collection('drivers');
  final CollectionReference busesCollection =
      FirebaseFirestore.instance.collection('buses');

  Future<void> addDriver(Driver driver) {
    return driversCollection.doc(driver.driverId).set(driver.toJson());
  }

  Future<void> deleteDriver(String driverId) {
    return driversCollection.doc(driverId).delete();
  }

  Future<Driver?> getDriverById(String driverId) async {
    DocumentSnapshot snapshot = await driversCollection.doc(driverId).get();
    if (snapshot.exists) {
      return Driver.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<Driver>> getAllDrivers() async {
    QuerySnapshot snapshot = await driversCollection.get();
    List<Driver> drivers = snapshot.docs
        .map((doc) => Driver.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return drivers;
  }

  Future<void> updateDriver(Driver driver) {
    return driversCollection.doc(driver.driverId).update(driver.toJson());
  }

  Future<Driver?> getDriverByUsernameAndPassword(
      String username, String password) async {
    QuerySnapshot snapshot = await driversCollection
        .where('licenseNumber', isEqualTo: username)
        .where('contactInfo', isEqualTo: password)
        .get();

    if (snapshot.size > 0) {
      var data = snapshot.docs.first.data();
      return Driver.fromJson(data as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<Bus?> getBusByDriverId(String driverId) async {
    QuerySnapshot snapshot =
        await busesCollection.where('driverId', isEqualTo: driverId).get();

    if (snapshot.size > 0) {
      var data = snapshot.docs.first.data();
      return Bus.fromJson(data as Map<String, dynamic>);
    } else {
      return null;
    }
  }
  
}
