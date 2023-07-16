import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/admin/admin_drawer.dart';
import 'package:bus_booking/services/auth_services.dart';
import 'package:bus_booking/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/routes.gr.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<FirebsaeAuthMethods>().signOut().then((value) {
                showSnackBar(context, 'Logged out successfully');
                context.router.replace(const LoginRoute());
              });
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Admin Home'),
      ),
    );
  }
}
