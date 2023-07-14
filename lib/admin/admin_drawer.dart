import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/admin/widgets/edit_display_name.dart';
import 'package:bus_booking/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/routes.gr.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.read<FirebsaeAuthMethods>().user;
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Row(
              children: [
                Text(user.displayName ?? 'User'),
                const SizedBox(width: 10),
                const EditDisplayName(),
              ],
            ),
            accountEmail: Text(user.email ?? 'Email'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.router.replace(const AdminRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Manage Drivers'),
            onTap: () {
              context.router.replace(const ManageDriverRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_bus),
            title: const Text('Manage Bus'),
            onTap: () {
              context.router.replace(const ManageBusRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Route'),
            onTap: () {
              context.router.replace(const ManageRouteRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Schedule'),
            onTap: () {
              context.router.replace(const ManageScheduleRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('View Booking'),
            onTap: () {
              context.router.replace(const ViewBookingRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Users'),
            onTap: () {
              context.router.replace(const ViewUserRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_sharp),
            title: const Text('Logout'),
            onTap: () {
              context.read<FirebsaeAuthMethods>().signOut().then(
                    (value) => context.router.replace(
                      const LoginRoute(),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
