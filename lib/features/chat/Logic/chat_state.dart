part of 'chat_cubit.dart';

@immutable
sealed class ChatState {
  final List<Message> messages;
  final String? error;

  const ChatState({required this.messages, this.error});
}

final class ChatInitial extends ChatState {
  const ChatInitial() : super(messages: const []);
}

final class ChatLoading extends ChatState {
  const ChatLoading({required super.messages});
}

final class ChatSuccess extends ChatState {
  const ChatSuccess({required super.messages}) : super(error: null);
}

final class ChatError extends ChatState {
  const ChatError({required super.messages, required super.error});
}
