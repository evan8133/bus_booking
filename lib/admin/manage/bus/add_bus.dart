import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/services/bus_services.dart';
import 'package:bus_booking/utils/snackMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bus.dart';
import '../../../models/driver.dart';
import '../../../utils/button.dart';
import '../../../utils/input_box.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({Key? key}) : super(key: key);

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _driverIdController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving the bus
      final Bus newBus = Bus(
        registrationNumber: _registrationNumberController.text,
        model: _modelController.text,
        capacity: int.parse(_capacityController.text),
        driverId: _driverIdController.text,
      );
      context.read<BusService>().addBus(newBus).then((value) {
        showSnackBar(context, 'Bus Added Successfully');
        context.router.pop();
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _registrationNumberController.dispose();
    _modelController.dispose();
    _capacityController.dispose();
    _driverIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              MyTextField(
                controller: _registrationNumberController,
                labelText: 'Registration Number',
                hintText: 'Enter registration number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the registration number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              MyTextField(
                controller: _modelController,
                labelText: 'Model',
                hintText: 'Enter bus model',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bus model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              MyTextField(
                controller: _capacityController,
                labelText: 'Capacity',
                hintText: 'Enter bus capacity',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bus capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              MyTextField(
                controller: _driverIdController,
                labelText: 'Driver ID',
                hintText: 'Enter driver ID',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the driver ID';
                  }
                  return null;
                },
                action: () async {
                  final driver =
                      await context.router.push(const SelectDriverRoute());
                  setState(() {
                    _driverIdController.text = (driver as Driver).driverId;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              MyButton(
                text: const Text('Save'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
