class Bus {
  String busId;
  String registrationNumber;
  String model;
  int capacity;
  String driverId;

  Bus({
    required this.busId,
    required this.registrationNumber,
    required this.model,
    required this.capacity,
    required this.driverId,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['busId'],
      registrationNumber: json['registrationNumber'],
      model: json['model'],
      capacity: json['capacity'],
      driverId: json['driverId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'registrationNumber': registrationNumber,
      'model': model,
      'capacity': capacity,
      'driverId': driverId,
    };
  }
}