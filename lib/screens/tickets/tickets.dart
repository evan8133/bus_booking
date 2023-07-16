import 'package:bus_booking/models/booking.dart';
import 'package:bus_booking/models/route.dart' as MyRoute;
import 'package:bus_booking/services/bus_services.dart';
import 'package:bus_booking/services/route_services.dart';
import 'package:bus_booking/services/schedule_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/bus.dart';
import '../../services/auth_services.dart';
import '../../services/users_services.dart';
import '../user_drawer.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  @override
  Widget build(BuildContext context) {
    var user = context.read<FirebsaeAuthMethods>().user;

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('My Tickets'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: context.read<UserService>().getTickets(user.uid),
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
                    future: context
                        .read<ScheduleService>()
                        .getScheduleById(ticket.scheduleId),
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
                      if (snapshot.data == null) {
                        return const Center(child: Text('No Tickets'));
                      }
                      if (snapshot.hasData) {
                        var schedule = snapshot.data;
                        return FutureBuilder(
                          future: Future.wait([
                            context
                                .read<RouteService>()
                                .getRouteById(schedule!.routeId),
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
                                  title: Text(
                                    '${route.start} - ${route.end}',
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ...schedule.departureTimes
                                          .map((time) => Text(
                                              DateFormat('jm').format(time)))
                                          .toList(),
                                      const Divider(),
                                      Text(
                                        '${bus.model} - ${bus.registrationNumber}',
                                      ),
                                      const Divider(),
                                      Text(
                                        'Booked on: ${DateTime.parse(ticket.date).toString().substring(0, 16)}',
                                      ),
                                      Text(
                                        'Valid for: ${DateTime.parse(ticket.date).add(const Duration(days: 3)).toString().substring(0, 16)} - (3-days)',
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
