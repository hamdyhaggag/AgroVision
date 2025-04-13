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

  ChatState copyWith({
    List<ChatSession>? sessions,
    String? currentSessionId,
    String? error,
  });

  List<Message> get messages {
    final session = sessions.firstWhere(
      (s) => s.id == currentSessionId,
      orElse: () => ChatSession(
        id: 'default',
        messages: [],
        createdAt: DateTime.now(),
      ),
    );
    return session.messages;
  }
}

final class ChatInitial extends ChatState {
  const ChatInitial() : super(sessions: const []);

  @override
  ChatState copyWith({
    List<ChatSession>? sessions,
    String? currentSessionId,
    String? error,
  }) {
    return ChatInitial();
  }
}

final class ChatLoading extends ChatState {
  const ChatLoading({
    required super.sessions,
    required super.currentSessionId,
  }) : super(error: null);

  @override
  ChatLoading copyWith({
    List<ChatSession>? sessions,
    String? currentSessionId,
    String? error,
  }) {
    return ChatLoading(
      sessions: sessions ?? this.sessions,
      currentSessionId: currentSessionId ?? this.currentSessionId,
    );
  }
}

final class ChatSuccess extends ChatState {
  const ChatSuccess({
    required super.sessions,
    required super.currentSessionId,
  }) : super(error: null);

  @override
  ChatSuccess copyWith({
    List<ChatSession>? sessions,
    String? currentSessionId,
    String? error,
  }) {
    return ChatSuccess(
      sessions: sessions ?? this.sessions,
      currentSessionId: currentSessionId ?? this.currentSessionId,
    );
  }

  @override
  List<Object?> get props => [sessions, currentSessionId];
}

final class ChatError extends ChatState {
  const ChatError({
    required super.sessions,
    required super.currentSessionId,
    required super.error,
  });

  @override
  ChatError copyWith({
    List<ChatSession>? sessions,
    String? currentSessionId,
    String? error,
  }) {
    return ChatError(
      sessions: sessions ?? this.sessions,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [sessions, currentSessionId, error];
}

class ChatNetworkError extends ChatState {
  final String error; // Non-nullable error
  final String lastMessage;
  final List<Message> pendingMessages;

  const ChatNetworkError({
    required super.sessions,
    required super.currentSessionId,
    required this.error, // Direct non-nullable property
    required this.lastMessage,
    required this.pendingMessages,
  }) : super(error: error); // Pass to super constructor

  @override
  ChatNetworkError copyWith({
    List<ChatSession>? sessions,
    String? currentSessionId,
    String? error,
    String? lastMessage,
    List<Message>? pendingMessages,
  }) {
    return ChatNetworkError(
      sessions: sessions ?? this.sessions,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      error: error ?? this.error,
      lastMessage: lastMessage ?? this.lastMessage,
      pendingMessages: pendingMessages ?? this.pendingMessages,
    );
  }

  @override
  List<Object?> get props => [
        sessions,
        currentSessionId,
        error,
        lastMessage,
        pendingMessages,
      ];
}
