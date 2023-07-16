import 'package:auto_route/auto_route.dart';
import 'package:bus_booking/routes/routes.gr.dart';
import 'package:bus_booking/utils/input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../models/bus.dart';
import '../../../models/schedule.dart';
import '../../../models/route.dart' as MyRoute;
import '../../../services/schedule_services.dart';

class EditScheduleScreen extends StatefulWidget {
  final Schedule schedule;

  const EditScheduleScreen({Key? key, required this.schedule})
      : super(key: key);

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final TextEditingController _routeIdController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();
  final List<TimeOfDay> _departureTimes = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _routeIdController.text = widget.schedule.routeId;
    _busIdController.text = widget.schedule.busId;
    _departureTimes.addAll(widget.schedule.departureTimes
        .map((dateTime) => TimeOfDay.fromDateTime(dateTime)));
  }

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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please add at least one departure time.'),
        ));
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
        scheduleId: widget.schedule.scheduleId,
        routeId: _routeIdController.text,
        busId: _busIdController.text,
        departureTimes: departureTimes,
      );

      // Update the schedule using the provided method
      context.read<ScheduleService>().updateSchedule(schedule).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Schedule updated successfully'),
        ));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
        ));
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
        title: const Text('Edit Schedule'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextField(
                controller: _routeIdController,
                hintText: 'Enter Route ID',
                labelText: 'Route ID',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Route ID cannot be empty';
                  }
                  return null;
                },
                action: () {
                  var route = context.router.push(const SelectRouteRoute());
                  setState(() {
                    _routeIdController.text = (route as MyRoute.Route).routeId;
                  });
                },
              ),
              SizedBox(height: 16.h),
              MyTextField(
                controller: _busIdController,
                hintText: 'Enter Bus ID',
                labelText: 'Bus ID',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bus ID cannot be empty';
                  }
                  return null;
                },
                action: () {
                  var bus = context.router.push(const SelectBusRoute());
                  setState(() {
                    _busIdController.text = (bus as Bus).busId;
                  });
                },
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
                child: const Text('Update Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
