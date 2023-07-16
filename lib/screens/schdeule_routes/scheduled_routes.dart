import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/models/schedule.dart';
import 'package:bus_booking/screens/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../models/bus.dart';
import '../../models/route.dart' as MyRoute;
import '../../routes/routes.gr.dart';
import '../../services/bus_services.dart';
import '../../services/route_services.dart';
import '../../services/schedule_services.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Object>(
            future: context.read<ScheduleService>().getAllSchedules(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot.hasData && snapshot.data == null) {
                return const Center(
                  child: Text('No data found'),
                );
              }
              List<Schedule> schedules = snapshot.data as List<Schedule>;
              return ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  Schedule schedule = schedules[index];
                  return FutureBuilder(
                    future: Future.wait<dynamic>([
                      context.read<BusService>().getBusById(schedule.busId),
                      context
                          .read<RouteService>()
                          .getRouteById(schedule.routeId),
                    ]),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      } else {
                        Bus bus = snapshot.data![0];
                        MyRoute.Route route = snapshot.data![1];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              context.router.push(
                                ViewScheduleRoutesRoute(
                                  schedule: schedule,
                                  bus: bus,
                                  route: route,
                                ),
                              );
                            },
                            leading: Icon(Icons.directions_bus),
                            title: Text('${bus.model} - ${route.name}'),
                            subtitle: Text(
                                'Start: ${route.start}, End: ${route.end}, Capacity: ${bus.capacity}'),
                            trailing:
                                Text('Bus Reg: ${bus.registrationNumber}'),
                          ),
                        );
                      }
                    },
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
