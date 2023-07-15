import 'package:uuid/uuid.dart';

class Schedule {
  String scheduleId;
  String routeId;
  String busId;
  List<DateTime> departureTimes;

  Schedule({
    String? scheduleId,
    required this.routeId,
    required this.busId,
    List<DateTime>? departureTimes,
  })  : scheduleId = scheduleId ?? const Uuid().v4(),
        departureTimes = departureTimes ?? [];

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final List<dynamic> departureTimesJson = json['departureTimes'];
    final List<DateTime> departureTimes =
        departureTimesJson.map((time) => DateTime.parse(time)).toList();

    return Schedule(
      scheduleId: json['scheduleId'],
      routeId: json['routeId'],
      busId: json['busId'],
      departureTimes: departureTimes,
    );
  }

  Map<String, dynamic> toJson() {
    final List<String> departureTimesJson =
        departureTimes.map((time) => time.toIso8601String()).toList();

    return {
      'scheduleId': scheduleId,
      'routeId': routeId,
      'busId': busId,
      'departureTimes': departureTimesJson,
    };
  }
}
