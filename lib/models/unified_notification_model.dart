import 'package:equatable/equatable.dart';

enum NotificationType {
  order,
  general,
  system,
}

class UnifiedNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final NotificationType type;
  final Map<String, dynamic>? metadata;

  const UnifiedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.type,
    this.metadata,
  });

  factory UnifiedNotification.fromOrderNotification(dynamic notification) {
    return UnifiedNotification(
      id: notification.id.toString(),
      title: notification.title,
      body: notification.body,
      isRead: notification.isRead,
      createdAt: notification.createdAt,
      type: NotificationType.order,
      metadata: {
        'order_id': notification.id,
        'user_id': notification.userId,
      },
    );
  }

  factory UnifiedNotification.fromGeneralNotification(dynamic notification) {
    return UnifiedNotification(
      id: notification.id,
      title: notification.title,
      body: notification.description,
      isRead: !notification.isUnread,
      createdAt: notification.timestamp,
      type: NotificationType.general,
      metadata: {
        'type': notification.type,
      },
    );
  }

  @override
  List<Object?> get props =>
      [id, title, body, isRead, createdAt, type, metadata];

  String get category {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (createdAt.isAfter(today)) {
      return 'Today';
    } else if (createdAt.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return 'Older';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }
}
