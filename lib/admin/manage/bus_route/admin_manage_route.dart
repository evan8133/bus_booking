import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/services/route_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../admin_drawer.dart';

class ManageRouteScreen extends StatefulWidget {
  const ManageRouteScreen({super.key});

  @override
  State<ManageRouteScreen> createState() => _ManageRouteScreenState();
}

class _ManageRouteScreenState extends State<ManageRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AdminDrawer(),
        appBar: AppBar(
          title: const Text('Manage Route'),
          actions: [
            IconButton(
              onPressed: () {
                context.router.push(const AddRouteRoute());
              },
              icon: const Icon(Icons.add_location_alt_sharp),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: context.read<RouteService>().getAllRoutes(),
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
              final routes = snapshot.data;
              return ListView.builder(
                itemCount: routes!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        'Name: ${routes[index].name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              'Start:${routes[index].start}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              'End: ${routes[index].end}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Edit button logic
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                          IconButton(
                            onPressed: () {
                              // Delete button logic
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () {
                              context.router.push(
                                ViewRouteInfoRoute(
                                  route: routes[index],
                                ),
                              );
                            },
                            icon: const Icon(Icons.visibility),
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
