// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/utils/snackMessage.dart';
import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../services/driver_services.dart';
import '../utils/button.dart';
import '../utils/input_box.dart';

class DriverLoginScreen extends StatefulWidget {
  @override
  _DriverLoginScreenState createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DriverService _driverService = DriverService();
  String _errorMessage = '';

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Perform validation here if needed

    Driver? driver = await _driverService.getDriverByUsernameAndPassword(
      username,
      password,
    );

    if (driver != null) {
      showSnackBar(context, 'Login successful');
      context.router.replace(
        DriverViewRoute(
          driver: driver,
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Driver Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            MyTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Enter your username',
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            MyButton(
              text: const Text('Login'),
              onPressed: _login,
            ),
          ],
        ),
      ),
    );
  }
}
