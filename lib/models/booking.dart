import 'package:uuid/uuid.dart';

class Booking {
  String bookingId;
  String userId;
  String scheduleId;
  String date;
  int numberOfPersons;

  Booking({
    String? bookingId,
    required this.userId,
    required this.scheduleId,
    required this.date,
    required this.numberOfPersons,
  }) : bookingId = bookingId ?? Uuid().v4();

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      userId: json['userId'],
      scheduleId: json['scheduleId'],
      date: json['date'],
      numberOfPersons: json['numberOfPersons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'scheduleId': scheduleId,
      'date': date,
      'numberOfPersons': numberOfPersons,
    };
  }
}
