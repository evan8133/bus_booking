import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../models/bus.dart';
import '../../models/route.dart' as MyRoute;
import '../../models/schedule.dart';
import '../../models/user.dart';
import '../../services/bus_services.dart';
import '../../services/route_services.dart';
import '../../services/schedule_services.dart';
import '../../services/users_services.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: context.read<UserService>().getAllBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (snapshot.hasData) {
              var tickets = snapshot.data as List<Booking>;
              return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  var ticket = tickets[index];
                  return FutureBuilder(
                    future: Future.wait([
                      context
                          .read<ScheduleService>()
                          .getScheduleById(ticket.scheduleId),
                      context.read<UserService>().getUserById(ticket.userId),
                    ]),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error'),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Center(child: Text('No Tickets'));
                      }
                      if (snapshot.hasData) {
                        var schedule = snapshot.data![0] as Schedule;
                        var user = snapshot.data![1] as User;
                        return FutureBuilder(
                          future: Future.wait([
                            context
                                .read<RouteService>()
                                .getRouteById(schedule.routeId),
                            context
                                .read<BusService>()
                                .getBusById(schedule.busId),
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error'),
                              );
                            }
                            if (snapshot.hasData) {
                              var route = snapshot.data![0] as MyRoute.Route;
                              var bus = snapshot.data![1] as Bus;
                              return Card(
                                child: ListTile(
                                  title: FittedBox(
                                    child: Text(
                                      'Name :${user.name} - ${user.phone}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Route Name ${route.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        'Route Start : ${route.start}\nRoute End: ${route.end}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const Divider(),
                                      Text(
                                        'Departure Times',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      ...schedule.departureTimes
                                          .map((time) => Text(
                                              DateFormat('jm').format(time)))
                                          .toList(),
                                      const Divider(),
                                      Text(
                                        '${bus.model} - ${bus.registrationNumber}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const Divider(),
                                      Text(
                                        'Booked on: ${DateTime.parse(ticket.date).toString().substring(0, 16)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        'Valid for: ${DateTime.parse(ticket.date).add(const Duration(days: 3)).toString().substring(0, 16)} - (3-days)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  leading: Icon(
                                    Icons.directions_bus,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: Text('No Tickets'),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: Text('No Tickets'),
                      );
                    },
                  );
                },
              );
            }
            return const Center(
              child: Text('No Tickets'),
            );
          },
        ),
      ),
    );
  }
}
