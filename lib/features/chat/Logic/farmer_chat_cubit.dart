// farmer_chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_error_handler.dart';
import '../../../core/network/api_service.dart';
import 'farmer_chat_state.dart';

class FarmerChatCubit extends Cubit<FarmerChatState> {
  final ApiService _apiService;

  FarmerChatCubit(this._apiService) : super(FarmerChatInitial());

  Future<void> loadConversations() async {
    emit(FarmerChatLoading());
    try {
      final response = await _apiService.getConversations();
      emit(FarmerChatLoaded(response.data));
    } on ErrorHandler catch (error) {
      emit(FarmerChatError(error.apiErrorModel.message ?? 'Unknown error'));
    }
  }

  Future<void> startNewConversation(int userId) async {
    try {
      final response = await _apiService.createConversation({
        'user2_id': userId,
      });
      await loadConversations();
    } on ErrorHandler catch (error) {
      // Handle error
    }
  }

  Future<void> sendMessage({
    required int conversationId,
    required String message,
    required int receiverId,
  }) async {
    try {
      final response = await _apiService.sendMessage({
        'conversation_id': conversationId,
        'message': message,
      });
      await loadConversations();
    } on ErrorHandler catch (error) {
      // Handle error
    }
  }

  Future<void> markMessageRead(int messageId) async {
    try {
      await _apiService.markMessageAsRead(messageId);
      await loadConversations();
    } on ErrorHandler catch (error) {
      // Handle error
    }
  }
}
