// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _checkUserStatusAndNavigate();
    super.initState();
  }

  Future<void> _checkUserStatusAndNavigate() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      if (currentUser != null && currentUser.uid.isNotEmpty) {
        DocumentSnapshot userDocument =
            await firestore.collection('users').doc(currentUser.uid).get();
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        log(userData.toString());
        if (userData.containsKey('role')) {
          if (userData['role'] == 'admin') {
            context.router.replace(const AdminRoute());
          } else {
            context.router.replace(const HomeRoute());
          }
        } else {
          context.router.replace(const LoginRoute());
        }
      } else {
        context.router.replace(const LoginRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/images/loading.gif',
      backgroundColor: Theme.of(context).colorScheme.primary,
      gifWidth: 269,
      gifHeight: 474,
      defaultNextScreen: null,
      duration: const Duration(seconds: 2),
      onInit: () async {},
      onEnd: () async {},
    );
  }
}
