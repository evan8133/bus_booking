import 'package:bus_booking/models/driver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/driver_services.dart';

class SelectDriverScreen extends StatefulWidget {
  const SelectDriverScreen({super.key});

  @override
  State<SelectDriverScreen> createState() => _SelectDriverScreenState();
}

class _SelectDriverScreenState extends State<SelectDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Driver'),
      ),
      body: FutureBuilder(
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
          if (snapshot.hasData && (snapshot.data as List).isEmpty) {
            return const Center(
              child: Text('No Drivers Found, Please Add Drivers'),
            );
          }
          final List<Driver> drivers = snapshot.data as List<Driver>;
          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return Card(
                child: ListTile(
                  leading:
                      const Icon(Icons.person), // Add an icon for the driver
                  title: Text(
                    driver.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 16), // Add an icon for contact info
                          const SizedBox(width: 5),
                          Text(
                            driver.contactInfo,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.card_membership,
                              size: 16), // Add an icon for license number
                          const SizedBox(width: 5),
                          Text(
                            driver.licenseNumber,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons
                      .arrow_forward), // Add an arrow icon for the right side
                  onTap: () {
                    Navigator.pop(context, driver);
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
