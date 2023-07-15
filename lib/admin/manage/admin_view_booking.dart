import 'package:flutter/material.dart';

import '../admin_drawer.dart';

class ViewBookingScreen extends StatefulWidget {
  const ViewBookingScreen({super.key});

  @override
  State<ViewBookingScreen> createState() => _ViewBookingScreenState();
}

class _ViewBookingScreenState extends State<ViewBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('View Booking'),
      ),
      body: const Placeholder(),
    );
  }
}
