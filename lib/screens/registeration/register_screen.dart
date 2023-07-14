import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/services/auth_services.dart';
import 'package:bus_booking/utils/button.dart';
import 'package:bus_booking/utils/input_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _key = GlobalKey<FormState>();
  final controllerFullName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
  final controllerPhone = TextEditingController();

  void submit(BuildContext context) {
    if (_key.currentState!.validate()) {
      context.read<FirebsaeAuthMethods>().signUpWithEmail(
            password: controllerConfirmPassword.text,
            userData: {
              'name': controllerFullName.text,
              'email': controllerEmail.text,
              'phone': controllerPhone.text,
            },
            context: context,
          );
    } else {
      log('Not Validated');
    }
  }

  @override
  void dispose() {
    controllerFullName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controllerFullName,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controllerEmail,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(p0) ==
                        false) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controllerPhone,
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (p0.length > 12) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controllerPassword,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (p0.length < 8) {
                      return 'Password must be at least 6 characters';
                    }
                    if (RegExp(
                            r"^(?=.[a-z])(?=.[A-Z])(?=.\d)(?=.[@$!%?&])[A-Za-z\d@$!%?&]+$")
                        .hasMatch(p0)) {
                      return 'Password must contain at least one uppercase letter, one lowercase letter and one number';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controllerConfirmPassword,
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password again',
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'Please enter your password again';
                    }
                    if (controllerPassword.text !=
                        controllerConfirmPassword.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    text: const Text('Sign Up'),
                    onPressed: () {
                      submit(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
