import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
}
