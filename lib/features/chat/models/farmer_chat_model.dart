import 'package:json_annotation/json_annotation.dart';

part 'farmer_chat_model.g.dart';

@JsonSerializable()
class ConversationsResponse {
  final List<Conversation> conversations;

  ConversationsResponse({required this.conversations});

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationsResponseToJson(this);
}

@JsonSerializable()
class Conversation {
  final int id;
  @JsonKey(name: 'user1_id')
  final int user1Id;
  @JsonKey(name: 'user1_name')
  final String user1Name;
  @JsonKey(name: 'user1_img')
  final String? user1Img;
  @JsonKey(name: 'user2_id')
  final int user2Id;
  @JsonKey(name: 'user2_name')
  final String user2Name;
  @JsonKey(name: 'user2_img')
  final String? user2Img;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'unread_count', defaultValue: 0)
  final int unreadCount;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user1Name,
    this.user1Img,
    required this.user2Id,
    required this.user2Name,
    this.user2Img,
    required this.createdAt,
    required this.unreadCount,
    this.messages = const [],
  });

  int get otherUserId {
    final currentId = _currentUserId;
    if (currentId == 0) return user2Id; // Default to user2 if no current user
    return user1Id == currentId ? user2Id : user1Id;
  }

  static int _currentUserId = 0;

  static void setCurrentUserId(int id) {
    _currentUserId = id;
  }

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  Conversation copyWith({
    int? id,
    int? user1Id,
    String? user1Name,
    String? user1Img,
    int? user2Id,
    String? user2Name,
    String? user2Img,
    DateTime? createdAt,
    int? unreadCount,
    List<Message>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user1Name: user1Name ?? this.user1Name,
      user1Img: user1Img ?? this.user1Img,
      user2Id: user2Id ?? this.user2Id,
      user2Name: user2Name ?? this.user2Name,
      user2Img: user2Img ?? this.user2Img,
      createdAt: createdAt ?? this.createdAt,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }
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

  DateTime get timestamp => createdAt;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    int? receiverId,
    String? message,
    int? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
