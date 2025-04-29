class Sensor {
  final String id;
  final String status;
  final DateTime lastSeen;
  final String? issue;
  final String name;
  final String type;

  Sensor({
    required this.id,
    required this.status,
    required this.lastSeen,
    this.issue,
    this.name = 'Agricultural Sensor',
    this.type = 'Soil Monitor',
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    if (json['sensor_id'] == null ||
        json['status'] == null ||
        json['last_seen'] == null) {
      throw const FormatException('Invalid sensor data');
    }

    DateTime parsedDate;
    try {
      parsedDate =
          DateTime.parse(json['last_seen'].toString().replaceAll(' ', 'T'));
    } catch (e) {
      parsedDate = DateTime.now().subtract(const Duration(hours: 1));
    }

    return Sensor(
      id: json['sensor_id'].toString(),
      status: json['status'].toString(),
      lastSeen: parsedDate,
      issue: json['issue']?.toString(),
    );
  }
}
