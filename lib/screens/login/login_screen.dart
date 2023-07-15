
import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/utils/button.dart';
import 'package:bus_booking/utils/input_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void loginUser() {
    setState(() {
      isLoading = true;
    });
    if (_key.currentState!.validate()) {
      context
          .read<FirebsaeAuthMethods>()
          .loginWithEmail(
            email: usernameController.text,
            password: passwordController.text,
            context: context,
          )
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                  ),
                  MyTextField(
                    controller: usernameController,
                    labelText: 'Username',
                    hintText: 'Enter your email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: isLoading
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : const Text('Login'),
                      onPressed: () {
                        loginUser();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: const Text('Sign Up'),
                      onPressed: () {
                        context.router.push(const RegisterationRoute());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
