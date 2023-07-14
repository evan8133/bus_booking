import 'package:uuid/uuid.dart';

class Schedule {
  String scheduleId;
  String routeId;
  String driverId;
  String busId;
  String date;

  Schedule({
    String? scheduleId,
    required this.routeId,
    required this.driverId,
    required this.busId,
    required this.date,
  }) : scheduleId = scheduleId ?? Uuid().v4();

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      routeId: json['routeId'],
      driverId: json['driverId'],
      busId: json['busId'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'routeId': routeId,
      'driverId': driverId,
      'busId': busId,
      'date': date,
    };
  }
}
