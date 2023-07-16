import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/screens/user_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/routes.gr.dart';
import '../../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<FirebsaeAuthMethods>().signOut().then(
                    (value) => context.router.replace(
                      const LoginRoute(),
                    ),
                  );
            },
          )
        ],
      ),
    );
  }
}
