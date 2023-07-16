import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/schedule.dart';

class ScheduleService {
  final CollectionReference schedulesCollection =
      FirebaseFirestore.instance.collection('schedules');

  Future<void> addSchedule(Schedule schedule) {
    return schedulesCollection.doc(schedule.scheduleId).set(schedule.toJson());
  }

  Future<void> deleteSchedule(String scheduleId) {
    return schedulesCollection.doc(scheduleId).delete();
  }

  Future<Schedule?> getScheduleById(String scheduleId) async {
    DocumentSnapshot snapshot = await schedulesCollection.doc(scheduleId).get();
    if (snapshot.exists) {
      return Schedule.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<Schedule>> getAllSchedules() async {
    QuerySnapshot snapshot = await schedulesCollection.get();
    List<Schedule> schedules = snapshot.docs
        .map((doc) => Schedule.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return schedules;
  }

  //update schedule
  Future<void> updateSchedule(Schedule schedule) {
    return schedulesCollection
        .doc(schedule.scheduleId)
        .update(schedule.toJson());
  }

  Future<Schedule?> getScheduleByBusId(String busId) async {
    QuerySnapshot snapshot =
        await schedulesCollection.where('busId', isEqualTo: busId).get();

    if (snapshot.size > 0) {
      var data = snapshot.docs.first.data();
      return Schedule.fromJson(data as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
