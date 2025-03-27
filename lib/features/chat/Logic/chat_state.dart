part of 'chat_cubit.dart';

@immutable
sealed class ChatState {
  final List<ChatSession> sessions;
  final String? currentSessionId;
  final String? error;

  const ChatState({
    required this.sessions,
    this.currentSessionId,
    this.error,
  });

  List<Message> get messages =>
      sessions.firstWhere((s) => s.id == currentSessionId).messages;
}

final class ChatInitial extends ChatState {
  const ChatInitial() : super(sessions: const []);
}

final class ChatLoading extends ChatState {
  const ChatLoading({
    required super.sessions,
    required super.currentSessionId,
  });
}

final class ChatSuccess extends ChatState {
  const ChatSuccess({
    required super.sessions,
    required super.currentSessionId,
  }) : super(error: null);
}

final class ChatError extends ChatState {
  const ChatError({
    required super.sessions,
    required super.currentSessionId,
    required super.error,
  });
}
