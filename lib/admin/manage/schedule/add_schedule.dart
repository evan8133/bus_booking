import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/models/bus.dart';
import 'package:bus_booking/models/schedule.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../services/schedule_services.dart';
import '../../../utils/input_box.dart';
import '../../../utils/snackMessage.dart';
import '../../../models/route.dart' as MyRoute;

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({Key? key}) : super(key: key);

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final TextEditingController _routeIdController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();
  final List<TimeOfDay> _departureTimes = [];

  final _formKey = GlobalKey<FormState>();

  void _addDepartureTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          _departureTimes.add(selectedTime);
        });
      }
    });
  }

  void _deleteDepartureTime(int index) {
    setState(() {
      _departureTimes.removeAt(index);
    });
  }

  void _saveSchedule() {
    if (_formKey.currentState?.validate() == true) {
      if (_departureTimes.isEmpty) {
        showSnackBar(context, 'Please add at least one departure time.');
        return;
      }

      final List<DateTime> departureTimes = _departureTimes
          .map((timeOfDay) => DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                timeOfDay.hour,
                timeOfDay.minute,
              ))
          .toList();

      Schedule schedule = Schedule(
        routeId: _routeIdController.text,
        busId: _busIdController.text,
        departureTimes: departureTimes,
      );

      context.read<ScheduleService>().addSchedule(schedule).then((value) {
        showSnackBar(context, 'Schedule added successfully');
        context.router.pop();
      }).catchError((error) {
        showSnackBar(context, error.toString());
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _routeIdController.dispose();
    _busIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextField(
                controller: _routeIdController,
                labelText: 'Route ID',
                hintText: 'Enter Route ID',
                keyboardType: TextInputType.text,
                action: () async {
                  var route =
                      await context.router.push(const SelectRouteRoute());
                  setState(() {
                    _routeIdController.text = (route as MyRoute.Route).routeId;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Route ID cannot be empty';
                  }
                  return null;
                },
                actionIcon: const Icon(Icons.search),
              ),
              SizedBox(height: 16.h),
              MyTextField(
                controller: _busIdController,
                labelText: 'Bus ID',
                hintText: 'Enter Bus ID',
                keyboardType: TextInputType.text,
                action: () async {
                  var bus = await context.router.push(const SelectBusRoute());
                  setState(() {
                    _busIdController.text = (bus as Bus).busId;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bus ID cannot be empty';
                  }
                  return null;
                },
                actionIcon: const Icon(Icons.search),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _addDepartureTime,
                child: const Text('Add Departure Time'),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _departureTimes.length,
                  itemBuilder: (context, index) {
                    final time = _departureTimes[index];
                    return ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(time.format(context)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteDepartureTime(index),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _saveSchedule,
                child: const Text('Save Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
