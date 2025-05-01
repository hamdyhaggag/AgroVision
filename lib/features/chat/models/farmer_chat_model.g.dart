// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationsResponse _$ConversationsResponseFromJson(
        Map<String, dynamic> json) =>
    ConversationsResponse(
      conversations: (json['conversations'] as List<dynamic>)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationsResponseToJson(
        ConversationsResponse instance) =>
    <String, dynamic>{
      'conversations': instance.conversations,
    };

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      id: (json['id'] as num).toInt(),
      user1Id: (json['user1_id'] as num).toInt(),
      user1Name: json['user1_name'] as String,
      user1Img: json['user1_img'] as String?,
      user2Id: (json['user2_id'] as num).toInt(),
      user2Name: json['user2_name'] as String,
      user2Img: json['user2_img'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1_id': instance.user1Id,
      'user1_name': instance.user1Name,
      'user1_img': instance.user1Img,
      'user2_id': instance.user2Id,
      'user2_name': instance.user2Name,
      'user2_img': instance.user2Img,
      'created_at': instance.createdAt.toIso8601String(),
      'unread_count': instance.unreadCount,
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
