// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      id: (json['id'] as num).toInt(),
      user1Id: (json['user1_id'] as num).toInt(),
      user2Id: (json['user2_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1_id': instance.user1Id,
      'user2_id': instance.user2Id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'messages': instance.messages,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: (json['id'] as num).toInt(),
      conversationId: (json['conversation_id'] as num).toInt(),
      senderId: (json['sender_id'] as num).toInt(),
      receiverId: (json['receiver_id'] as num).toInt(),
      message: json['message'] as String,
      isRead: (json['is_read'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'receiver_id': instance.receiverId,
      'message': instance.message,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
