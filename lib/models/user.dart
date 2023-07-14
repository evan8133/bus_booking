import 'package:uuid/uuid.dart';

class User {
  String userId;
  String name;
  String email;
  String phone;
  String role;

  User({
    String? userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  }) : userId = userId ?? const Uuid().v4();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
