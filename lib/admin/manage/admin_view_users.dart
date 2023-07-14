import 'package:bus_booking/services/users_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../admin_drawer.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('View User'),
      ),
      body: FutureBuilder(
        future: context.read<UserService>().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData &&
              (snapshot.data as List<User>).isEmpty) {
            return const Center(
              child: Text('No Users Had been Registered'),
            );
          } else {
            List<User> users = snapshot.data as List<User>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final User user = users[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user.email}'),
                          Text('Phone: ${user.phone}'),
                        ],
                      ),
                      trailing: Text('Role: ${user.role}'),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
