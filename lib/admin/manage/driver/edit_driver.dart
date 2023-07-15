// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/driver.dart';
import '../../../services/driver_services.dart';
import '../../../utils/button.dart';
import '../../../utils/input_box.dart';
import '../../../utils/snackMessage.dart';

class EditDriverScreen extends StatefulWidget {
  Driver driver;

  EditDriverScreen({super.key, required this.driver});

  @override
  State<EditDriverScreen> createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.driver.name;
    _licenseNumberController.text = widget.driver.licenseNumber;
    _contactInfoController.text = widget.driver.contactInfo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseNumberController.dispose();
    _contactInfoController.dispose();
    super.dispose();
  }

  void _editDriver() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      Driver driver = Driver(
          driverId: widget.driver.driverId,
          name: _nameController.text,
          licenseNumber: _licenseNumberController.text,
          contactInfo: _contactInfoController.text);
      await context.read<DriverService>().updateDriver(driver).then((value) {
        showSnackBar(context, 'Driver Updated Successfully');
        setState(() {
          isLoading = false;
          context.router.pop();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Driver'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  if (value.length < 4) {
                    return 'Name must be at least 4 characters long';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.h),
              MyTextField(
                controller: _licenseNumberController,
                labelText: 'License Number',
                hintText: 'Enter license number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a license number';
                  }
                  if (value.length < 10) {
                    return 'License number must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              MyTextField(
                controller: _contactInfoController,
                labelText: 'Contact Info',
                hintText: 'Enter contact info',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact info';
                  }
                  if (value.length < 10) {
                    return 'Contact info must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  text: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : const Text('Add Driver'),
                  onPressed: _editDriver,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
