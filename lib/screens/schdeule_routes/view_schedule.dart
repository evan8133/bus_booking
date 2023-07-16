import 'package:bus_booking/models/schedule.dart';
import 'package:flutter/material.dart';

class ViewScheduleRoutesScreen extends StatefulWidget {
  Schedule schedule;
  ViewScheduleRoutesScreen({super.key, required this.schedule});

  @override
  State<ViewScheduleRoutesScreen> createState() => _ViewScheduleRoutesScreenState();
}

class _ViewScheduleRoutesScreenState extends State<ViewScheduleRoutesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}