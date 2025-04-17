import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/farmer_chat_model.dart';
import '../services/farmer_chat_api_service.dart';
import 'farmer_chat_state.dart';

class FarmerChatCubit extends Cubit<FarmerChatState> {
  final FarmerChatApiService _service;
  Timer? _pollingTimer;

  FarmerChatCubit(this._service) : super(FarmerChatInitial()) {
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      loadConversations();
    });
  }

  Future<void> loadConversations() async {
    try {
      final response = await _service.getConversations();
      if (state is FarmerChatLoaded) {
        final currentState = state as FarmerChatLoaded;
        emit(FarmerChatLoaded(response.data, isOptimistic: false));
      } else {
        emit(FarmerChatLoaded(response.data));
      }
    } on DioException catch (e) {
      emit(FarmerChatError(e.message ?? 'Failed to load conversations'));
    }
  }

  Future<void> sendMessage({
    required int conversationId,
    required String message,
    required int senderId,
  }) async {
    final currentState = state;
    if (currentState is! FarmerChatLoaded) return;

    final convIndex =
        currentState.conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex == -1) return;

    final conversation = currentState.conversations[convIndex];
    final newMessage = Message(
      id: -1,
      message: message,
      senderId: senderId,
      receiverId: conversation.otherUserId,
      conversationId: conversationId,
      isRead: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final updatedConv = currentState.conversations[convIndex].copyWith(
      messages: [...currentState.conversations[convIndex].messages, newMessage],
    );

    final updatedConvs = List<Conversation>.from(currentState.conversations);
    updatedConvs[convIndex] = updatedConv;

    emit(FarmerChatLoaded(updatedConvs, isOptimistic: true));

    try {
      await _service.sendMessage({
        'conversation_id': conversationId,
        'message': message,
      });

      await loadConversations();
    } on DioException catch (e) {
      emit(currentState);
      emit(FarmerChatError(e.message ?? 'Failed to send message'));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
