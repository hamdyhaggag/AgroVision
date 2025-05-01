import 'dart:convert';

class Sensor {
  final int id;
  final String name;
  final String status;
  final DateTime lastSeen;
  final String? issue;

  Sensor({
    required this.id,
    required this.name,
    required this.status,
    required this.lastSeen,
    this.issue,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      issue: json['issue'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
      'issue': issue,
    };
  }
}
