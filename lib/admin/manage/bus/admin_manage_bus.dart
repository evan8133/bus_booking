import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/models/bus.dart';
import 'package:bus_booking/models/driver.dart';
import 'package:bus_booking/services/bus_services.dart';
import 'package:bus_booking/services/driver_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes/routes.gr.dart';
import '../../admin_drawer.dart';

class ManageBusScreen extends StatefulWidget {
  const ManageBusScreen({super.key});

  @override
  State<ManageBusScreen> createState() => _ManageBusScreenState();
}

class _ManageBusScreenState extends State<ManageBusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Manage Bus'),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const AddBusRoute());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: context.read<BusService>().getAllBuses(),
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
            if (snapshot.hasData && (snapshot.data as List<Bus>).isEmpty) {
              return const Center(
                child: Text('No Buses Found, Please Add Buses'),
              );
            }
            final List<Bus> buses = snapshot.data as List<Bus>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final Bus bus = buses[index];
                  final driver =
                      context.read<DriverService>().getDriverById(bus.driverId);
                  return Card(
                    child: ExpansionTile(
                      leading: const Icon(
                          Icons.directions_bus), // Add an icon for the bus
                      title: Text(
                        bus.model,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit button press
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete button press
                            },
                          ),
                        ],
                      ),
                      children: [
                        ListTile(
                          leading: const Icon(
                              Icons.person), // Add an icon for the driver
                          title: FutureBuilder<Driver?>(
                            future: driver,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Text('Driver not found');
                              }
                              final driver = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons
                                          .person_outline), // Add an icon for driver name
                                      const SizedBox(width: 5),
                                      Text(
                                        driver.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons
                                          .badge), // Add an icon for license number
                                      const SizedBox(width: 5),
                                      Text(
                                        driver.licenseNumber,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons
                                          .phone), // Add an icon for contact info
                                      const SizedBox(width: 5),
                                      Text(
                                        driver.contactInfo,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons
                              .confirmation_number), // Add an icon for registration number
                          title: Text(
                            'Registration Number: ${bus.registrationNumber}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                              Icons.people), // Add an icon for capacity
                          title: Text(
                            'Capacity: ${bus.capacity}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Add more ListTiles for additional bus information as needed
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
