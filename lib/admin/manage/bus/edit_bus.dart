import 'package:flutter/material.dart';

import '../../../models/bus.dart';
import '../../../utils/button.dart';
import '../../../utils/input_box.dart';

class EditBusScreen extends StatefulWidget {
  final Bus bus;

  EditBusScreen({Key? key, required this.bus}) : super(key: key);

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

      // TODO: Update the bus object in your desired storage or perform any other action

      // Navigate back or show a success message
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
        title: Text('Edit Bus'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
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
              ),
              SizedBox(height: 16.0),
              MyButton(
                text: Text('Update'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
