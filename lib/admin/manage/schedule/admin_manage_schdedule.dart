import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/services/bus_services.dart';
import 'package:bus_booking/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bus.dart';
import '../../../models/schedule.dart';
import '../../../routes/routes.gr.dart';
import '../../../services/route_services.dart';
import '../../../services/schedule_services.dart';
import '../../admin_drawer.dart';
import '../../../models/route.dart' as MyRoute;

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({Key? key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  void _showDeleteConfirmationDialog(BuildContext context, Schedule schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this schedule?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                context
                    .read<ScheduleService>()
                    .deleteSchedule(schedule.scheduleId)
                    .then((value) {
                  showSnackBar(context, 'Schedule deleted successfully');
                  setState(() {});
                  context.router.pop();
                }).catchError((error) {
                  showSnackBar(context, 'Error deleting schedule');
                  log(error.toString());
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _viewScheduleDetails(BuildContext context, Schedule schedule) {
    context.router.push(
      ViewScheduleRoute(schedule: schedule),
    );
  }

  void _editSchedule(BuildContext context, Schedule schedule) {
    // Navigate to edit schedule screen, passing the schedule object
    context.router.push(
      EditScheduleRoute(schedule: schedule),
    );
  }

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
          child: FutureBuilder<List<Schedule>>(
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
              final schedules = snapshot.data!;
              return ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: FutureBuilder<Bus?>(
                        future: context
                            .read<BusService>()
                            .getBusById(schedule.busId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading Bus...');
                          }
                          if (snapshot.hasError) {
                            return const Text('Error loading Bus');
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text('Bus not found');
                          }
                          final bus = snapshot.data!;
                          return Text(
                            'Bus: ${bus.registrationNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      subtitle: FutureBuilder<MyRoute.Route?>(
                        future: context
                            .read<RouteService>()
                            .getRouteById(schedule.routeId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading Route...');
                          }
                          if (snapshot.hasError) {
                            return const Text('Error loading Route');
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text('Route not found');
                          }
                          final route = snapshot.data!;
                          return Text(
                            'Route: ${route.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Handle delete action
                              _showDeleteConfirmationDialog(context, schedule);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle view action
                              _viewScheduleDetails(context, schedule);
                            },
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle edit action
                              _editSchedule(context, schedule);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        ],
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
