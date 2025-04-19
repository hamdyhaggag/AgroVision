part of 'chat_cubit.dart';

abstract class ChatState {
  final List<ChatSession> sessions;
  final String? currentSessionId;

  const ChatState({
    this.sessions = const [],
    this.currentSessionId,
  });
}

class ChatInitial extends ChatState {
  const ChatInitial() : super();
}

class ChatSuccess extends ChatState {
  final bool isCreatingSession;

  const ChatSuccess({
    required super.sessions,
    required super.currentSessionId,
    required this.isCreatingSession,
  });
}

class ChatLoading extends ChatState {
  const ChatLoading({
    required super.sessions,
    required super.currentSessionId,
  });
}

class ChatError extends ChatState {
  final String error;

  const ChatError({
    required super.sessions,
    required super.currentSessionId,
    required this.error,
  });
}

class ChatNetworkError extends ChatState {
  final String error;
  final String lastMessage;
  final List<Message> pendingMessages;

  const ChatNetworkError({
    required super.sessions,
    required super.currentSessionId,
    required this.error,
    required this.lastMessage,
    required this.pendingMessages,
  });
}
