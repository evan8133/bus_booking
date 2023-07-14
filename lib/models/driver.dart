import 'package:uuid/uuid.dart';

class Driver {
  String driverId;
  String name;
  String licenseNumber;
  String contactInfo;

  Driver({
    String? driverId,
    required this.name,
    required this.licenseNumber,
    required this.contactInfo,
  }) : driverId = driverId ?? const Uuid().v4();

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driverId'],
      name: json['name'],
      licenseNumber: json['licenseNumber'],
      contactInfo: json['contactInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'name': name,
      'licenseNumber': licenseNumber,
      'contactInfo': contactInfo,
    };
  }
}
