import 'package:bus_booking/models/bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/bus_services.dart';


class SelectBusScreen extends StatefulWidget {
  const SelectBusScreen({Key? key}) : super(key: key);

  @override
  State<SelectBusScreen> createState() => _SelectBusScreenState();
}

class _SelectBusScreenState extends State<SelectBusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus'),
      ),
      body: FutureBuilder<List<Bus>>(
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
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Buses Found, Please Add Buses'),
            );
          }
          final List<Bus> buses = snapshot.data!;
          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: Text(
                    bus.registrationNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Model: ${bus.model}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Capacity: ${bus.capacity}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.pop(context, bus);
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
