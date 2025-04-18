import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/farmer_chat_model.dart';
import '../services/farmer_chat_api_service.dart';
import 'farmer_chat_state.dart';

class FarmerChatCubit extends Cubit<FarmerChatState> {
  final FarmerChatApiService _service;
  late final IO.Socket _socket;

  FarmerChatCubit(this._service) : super(FarmerChatInitial()) {
    _connectSocket();
    loadConversations();
  }

  void _connectSocket() {
    _socket = IO.io('http://final.agrovision.ltd',
        IO.OptionBuilder().setTransports(['websocket']).build());
    _socket.onConnect((_) {});
    _socket.on('new_message', (payload) {
      final msg = Message.fromJson(payload as Map<String, dynamic>);
      final current = state;
      if (current is FarmerChatLoaded) {
        final convs = current.conversations.map((c) {
          if (c.id == msg.conversationId) {
            return c.copyWith(messages: [...c.messages, msg]);
          }
          return c;
        }).toList();
        emit(FarmerChatLoaded(convs, isOptimistic: false));
      }
    });
  }

  Future<void> loadConversations() async {
    try {
      final response = await _service.getConversations();
      final conversations = response.data.conversations;
      if (state is FarmerChatLoaded) {
        emit(FarmerChatLoaded(conversations, isOptimistic: false));
      } else {
        emit(FarmerChatLoaded(conversations));
      }
    } catch (e) {
      emit(FarmerChatError(e.toString()));
    }
  }

  Future<void> sendMessage(
      {required int conversationId,
      required String message,
      required int senderId}) async {
    final currentState = state;
    if (currentState is! FarmerChatLoaded) return;
    final convIndex =
        currentState.conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex == -1) return;
    final conversation = currentState.conversations[convIndex];
    final newMessage = Message(
        id: -1,
        conversationId: conversationId,
        senderId: senderId,
        receiverId: conversation.otherUserId,
        message: message,
        isRead: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    final updatedConv =
        conversation.copyWith(messages: [...conversation.messages, newMessage]);
    final updatedConvs = List<Conversation>.from(currentState.conversations);
    updatedConvs[convIndex] = updatedConv;
    emit(FarmerChatLoaded(updatedConvs, isOptimistic: true));
    try {
      await _service
          .sendMessage({'conversation_id': conversationId, 'message': message});
    } catch (e) {
      emit(currentState);
      emit(FarmerChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _socket.dispose();
    return super.close();
  }
}
