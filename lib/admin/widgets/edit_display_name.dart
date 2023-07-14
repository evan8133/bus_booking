
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';

class EditDisplayName extends StatelessWidget {
  const EditDisplayName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String newName = ''; 
            return AlertDialog(
              title: const Text('Edit Display Name'),
              content: TextField(
                onChanged: (value) {
                  newName = value; // Update the entered name
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    // Perform validation
                    if (newName.trim().isEmpty) {
                      // Display an error message if the name is empty
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please enter a valid name.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      context
                          .read<FirebsaeAuthMethods>()
                          .setDisplayName(newName);
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
