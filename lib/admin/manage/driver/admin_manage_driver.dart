import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/services/driver_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/driver.dart';
import '../../admin_drawer.dart';

class ManageDriverScreen extends StatefulWidget {
  const ManageDriverScreen({super.key});

  @override
  State<ManageDriverScreen> createState() => _ManageDriverScreenState();
}

class _ManageDriverScreenState extends State<ManageDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AdminDrawer(),
        appBar: AppBar(
          title: const Text('Manage Driver'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.router.push(const AddDriverRoute());
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: context.read<DriverService>().getAllDrivers(),
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
              if (snapshot.hasData && (snapshot.data as List<Driver>).isEmpty) {
                return const Center(
                  child: Text('No Drivers Found, Please Add Drivers'),
                );
              }
              final List<Driver> drivers = snapshot.data as List<Driver>;
              return ListView.builder(
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final Driver driver = drivers[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        driver.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.badge),
                              const SizedBox(width: 4),
                              Text(
                                driver.licenseNumber,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 4),
                              Text(
                                driver.contactInfo,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  context.router
                                      .push(EditDriverRoute(driver: driver));
                                },
                              ),
                              const SizedBox(height: 4),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Handle delete driver
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle tap on driver
                      },
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
