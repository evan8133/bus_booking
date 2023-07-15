import 'package:bus_booking/models/schedule.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ViewScheduleScreen extends StatefulWidget {
  Schedule schedule;
  ViewScheduleScreen({super.key, required this.schedule});

  @override
  State<ViewScheduleScreen> createState() => _ViewScheduleScreenState();
}

class _ViewScheduleScreenState extends State<ViewScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
