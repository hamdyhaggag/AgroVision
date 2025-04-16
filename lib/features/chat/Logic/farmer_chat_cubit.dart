import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/farmer_chat_api_service.dart';
import 'farmer_chat_state.dart';

class FarmerChatCubit extends Cubit<FarmerChatState> {
  final FarmerChatApiService _service;

  FarmerChatCubit(this._service) : super(FarmerChatInitial());

  Future<void> loadConversations() async {
    emit(FarmerChatLoading());
    try {
      final response = await _service.getConversations();
      emit(FarmerChatLoaded(response.data));
    } on DioException catch (e) {
      emit(FarmerChatError(e.message ?? 'Failed to load conversations'));
    }
  }

  Future<void> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    try {
      await _service.sendMessage({
        'conversation_id': conversationId,
        'message': message,
      });
      await loadConversations();
    } on DioException catch (e) {
      emit(FarmerChatError(e.message ?? 'Failed to send message'));
    }
  }
}
