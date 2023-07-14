class Schedule {
  String scheduleId;
  String routeId;
  String driverId;
  String busId;
  String date;

  Schedule({
    required this.scheduleId,
    required this.routeId,
    required this.driverId,
    required this.busId,
    required this.date,
  });

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