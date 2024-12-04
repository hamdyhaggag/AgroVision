class NotificationModel {
  final String title;
  final String description;
  final String timeAgo;
  final String category;
  final bool isUnread;

  NotificationModel({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.category,
    this.isUnread = false,
  });
}
