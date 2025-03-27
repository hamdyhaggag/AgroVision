import 'chat_message.dart';

class ChatSession {
  final String id;
  final List<Message> messages;
  final DateTime createdAt;
  final String? title;
  final int unreadCount;
  ChatSession({
    required this.id,
    required this.messages,
    required this.createdAt,
    this.title,
    this.unreadCount = 0,
  });

  ChatSession copyWith({
    String? id,
    List<Message>? messages,
    DateTime? createdAt,
    String? title,
    int? unreadCount,
  }) {
    return ChatSession(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'messages': messages.map((msg) => msg.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'title': title,
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'],
        messages: (json['messages'] as List)
            .map((msg) => Message.fromJson(msg))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        title: json['title'],
      );
}
