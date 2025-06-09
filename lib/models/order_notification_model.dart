class OrderNotification {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderNotification.fromJson(Map<String, dynamic> json) {
    return OrderNotification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 