import 'package:bus_booking/models/geolocation.dart';
import 'package:bus_booking/services/route_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectRouteScreen extends StatefulWidget {
  const SelectRouteScreen({Key? key}) : super(key: key);

  @override
  State<SelectRouteScreen> createState() => _SelectRouteScreenState();
}

class _SelectRouteScreenState extends State<SelectRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Route'),
      ),
      body: FutureBuilder<List<Route>>(
        future: context.read<RouteService>().getAllRoutes(),
        builder: (context, AsyncSnapshot<List<Route>> snapshot) {
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
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Routes Found, Please Add Routes'),
            );
          }
          final List<Route> routes = snapshot.data!;
          return ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.map),
                  title: Text(
                    route.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start: ${route.start}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'End: ${route.end}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.pop(context, route);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
