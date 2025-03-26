import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/chat_message.dart';
import '../chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit(this.repository) : super(const ChatInitial());

  Future<void> sendTextMessage(String text) async {
    final newMessage = Message(
      text: text,
      isSentByMe: true,
    );

    final loadingMessages = [...state.messages, newMessage];
    emit(ChatLoading(messages: loadingMessages));

    try {
      final response = await repository.sendText(text);
      final botMessage = Message(
        text: response.answer,
        isSentByMe: false,
      );

      emit(ChatSuccess(messages: [...loadingMessages, botMessage]));
    } catch (e) {
      emit(ChatError(messages: state.messages, error: e.toString()));
    }
  }

  void deleteMessage(Message message) {
    final updatedMessages = List<Message>.from(state.messages)
      ..removeWhere(
          (m) => m.timestamp == message.timestamp && m.text == message.text);

    emit(ChatSuccess(messages: updatedMessages));
  }
}
