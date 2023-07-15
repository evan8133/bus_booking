import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../models/schedule.dart';

class EditScheduleScreen extends StatefulWidget {
  Schedule schedule;
  EditScheduleScreen({super.key, required this.schedule});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
