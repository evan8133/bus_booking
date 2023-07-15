import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes/routes.gr.dart';
import '../../../services/schedule_services.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const AddScheduleRoute());
            },
            icon: const Icon(Icons.alarm_add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: context.read<ScheduleService>().getAllSchedules(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something Went Wrong'));
              }
              if (snapshot.data == null) {
                return const Center(child: Text('No Data Found'));
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text('No Data Found'));
              }
              final schedules = snapshot.data;
              return ListView.builder(
                itemCount: schedules!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        schedules[index].scheduleId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        schedules[index].routeId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          context.router.push(
                            EditScheduleRoute(
                              schedule: schedules[index],
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
