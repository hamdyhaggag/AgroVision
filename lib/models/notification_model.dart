class NotificationModel {
  final String title;
  final String description;
  final String timeAgo;
  bool isUnread;
  final String type;
  final DateTime timestamp;

  NotificationModel({
    required this.title,
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
}
