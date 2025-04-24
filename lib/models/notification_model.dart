class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  bool isUnread;
  final String type;
  final DateTime timestamp;

  NotificationModel({
    required this.title,
    required this.id,
    required this.description,
    required this.timeAgo,
    required this.isUnread,
    required this.type,
    required this.timestamp,
  });

  String get category {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (timestamp.isAfter(today)) {
      return 'Today';
    } else if (timestamp.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return 'Older';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timeAgo': timeAgo,
      'isUnread': isUnread,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timeAgo: json['timeAgo'],
      isUnread: json['isUnread'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
