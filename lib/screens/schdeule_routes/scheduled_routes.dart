import 'package:bus_booking/screens/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ScheduledRoutesScreen extends StatefulWidget {
  const ScheduledRoutesScreen({super.key});

  @override
  State<ScheduledRoutesScreen> createState() => _ScheduledRoutesScreenState();
}

class _ScheduledRoutesScreenState extends State<ScheduledRoutesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Scheduled Routes'),
        centerTitle: true,
      ),
      body: const Placeholder(),
    );
  }
}