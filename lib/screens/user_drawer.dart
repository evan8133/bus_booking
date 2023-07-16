import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/routes.gr.dart';
import '../services/auth_services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.read<FirebsaeAuthMethods>().user;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Name: ${user.displayName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            child: const ListTile(
              leading: Icon(CupertinoIcons.home),
              title: Text('Home'),
            ),
            onPressed: () {
              context.router.replace(const HomeRoute());
            },
          ),
          CupertinoButton(
            child: const ListTile(
              leading: Icon(CupertinoIcons.location),
              title: Text('Routes'),
            ),
            onPressed: () {
              context.router.replace(const ScheduledRoutesRoute());
            },
          ),
          CupertinoButton(
            child: const ListTile(
              leading: Icon(CupertinoIcons.ticket),
              title: Text('My Tickets'),
            ),
            onPressed: () {
              context.router.replace(const MyTicketsRoute());
            },
          ),
          CupertinoButton(
            child: const ListTile(
              leading: Icon(CupertinoIcons.square_arrow_left),
              title: Text('Logout'),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirmation'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        context.read<FirebsaeAuthMethods>().signOut().then(
                              (value) => context.router.replace(
                                const LoginRoute(),
                              ),
                            );
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
