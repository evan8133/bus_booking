import 'package:flutter/material.dart';

import '../../admin_drawer.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Manage Schedule'),
      ),
      body: const Placeholder(),
    );
  }
}
