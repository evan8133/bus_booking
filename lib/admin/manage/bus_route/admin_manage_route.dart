import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:flutter/material.dart';

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

      body: const Placeholder(),
    );
  }
}
