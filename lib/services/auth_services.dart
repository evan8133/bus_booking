// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/routes.gr.dart';
import '../utils/snackMessage.dart';

class FirebsaeAuthMethods {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebsaeAuthMethods(this._auth);
  User get user => _auth.currentUser!;
  Stream<User?> get authState => _auth.authStateChanges();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_auth.currentUser != null) {
        DocumentSnapshot userDocument = await _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;

        if (userData.containsKey('role')) {
          if (userData['role'] == 'admin') {
          } else {
            context.router.replace(const HomeRoute());
          }
        } else {
          showSnackBar(context, "Error: Could not login");
        }
      } else {
        showSnackBar(context, "Error: Could not login");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  Future<void> signUpWithEmail({
    required String password,
    required Map<String, dynamic> userData,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: password,
      );
      _auth.currentUser!.updateDisplayName(userData['name']);
      if (_auth.currentUser != null) {
        await _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({
          'name': userData['name'],
          'email': userData['email'],
          'phone': userData['phone'],
          'role': 'user',
        }).then((value) {
          showSnackBar(context, "Successfully signed up");
          context.router.pop();
        });
      } else {
        showSnackBar(context, "Error: Could not sign up");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      } else {
        showSnackBar(context, e.message!);
      }
    }
  }
}
