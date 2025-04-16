import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'farmer_chat_model.g.dart';

@JsonSerializable()
class Conversation {
  final int id;
  @JsonKey(name: 'user1_id')
  final int user1Id;
  @JsonKey(name: 'user2_id')
  final int user2Id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  int get otherUserId {
    final currentId = _currentUserId;
    return user1Id == currentId ? user2Id : user1Id;
  }

  final int _currentUserId = 0;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}

@JsonSerializable()
class Message {
  final int id;
  @JsonKey(name: 'conversation_id')
  final int conversationId;
  @JsonKey(name: 'sender_id')
  final int senderId;
  @JsonKey(name: 'receiver_id')
  final int receiverId;
  final String message;
  @JsonKey(name: 'is_read')
  final int isRead;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
