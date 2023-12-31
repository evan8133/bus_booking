import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/services/bus_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bus.dart';
import '../../../models/driver.dart';
import '../../../routes/routes.gr.dart';
import '../../../utils/button.dart';
import '../../../utils/input_box.dart';

class EditBusScreen extends StatefulWidget {
  final Bus bus;

  const EditBusScreen({Key? key, required this.bus}) : super(key: key);

  @override
  State<EditBusScreen> createState() => _EditBusScreenState();
}

class _EditBusScreenState extends State<EditBusScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _registrationNumberController;
  late TextEditingController _modelController;
  late TextEditingController _capacityController;
  late TextEditingController _driverIdController;

  @override
  void initState() {
    super.initState();
    _registrationNumberController =
        TextEditingController(text: widget.bus.registrationNumber);
    _modelController = TextEditingController(text: widget.bus.model);
    _capacityController =
        TextEditingController(text: widget.bus.capacity.toString());
    _driverIdController = TextEditingController(text: widget.bus.driverId);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with updating the bus
      widget.bus.registrationNumber = _registrationNumberController.text;
      widget.bus.model = _modelController.text;
      widget.bus.capacity = int.parse(_capacityController.text);
      widget.bus.driverId = _driverIdController.text;

      context.read<BusService>().updateBus(widget.bus).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bus updated successfully'),
          ),
        );
        context.router.pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating bus'),
          ),
        );
        context.router.pop();
      });
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
        title: const Text('Edit Bus'),
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
                text: const Text('Update'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
