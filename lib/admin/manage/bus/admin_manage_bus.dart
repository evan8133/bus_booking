import 'package:bus_booking/models/bus.dart';
import 'package:bus_booking/models/driver.dart';
import 'package:bus_booking/services/bus_services.dart';
import 'package:bus_booking/services/driver_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: const Text('Manage Bus'),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
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
          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final Bus bus = buses[index];
              return ListTile(
                title: Text(bus.model),
                subtitle: Text(bus.registrationNumber),
              );
            },
          );
        },
      ),
    );
  }
}
