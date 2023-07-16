import 'package:bus_booking/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('booking');

  Future<void> addUser(User user) {
    return usersCollection.doc(user.userId).set(user.toJson());
  }

  Future<void> deleteUser(String userId) {
    return usersCollection.doc(userId).delete();
  }

  Future<User?> getUserById(String userId) async {
    DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
    if (snapshot.exists) {
      return User.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    QuerySnapshot snapshot = await usersCollection.get();
    List<User> users = snapshot.docs
        .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return users;
  }

  Future<void> updateUser(User updatedUser) {
    return usersCollection.doc(updatedUser.userId).update(updatedUser.toJson());
  }

  Future<void> bookSchedule(String userId, Booking book) {
    return bookingCollection.doc(book.bookingId).set(book.toJson());
  }

  Future<List<Booking>> getTickets(String uid) {
    return bookingCollection.where('userId', isEqualTo: uid).get().then(
        (value) => value.docs
            .map((e) => Booking.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }
  Future<List<Booking>> getAllBookings() async {
    QuerySnapshot snapshot = await bookingCollection.get();
    List<Booking> bookings = snapshot.docs
        .map((doc) => Booking.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return bookings;
  }
}
