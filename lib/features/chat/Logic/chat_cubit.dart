import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/cache_helper.dart';
import '../../../models/chat_message.dart';
import '../../../models/chat_session.dart';
import '../chat_repository.dart';
import '../../authentication/Logic/auth cubit/auth_cubit.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final AuthCubit authCubit;
  final List<Message> _pendingMessages = [];
  List<Message> get pendingMessages => _pendingMessages;

  ChatCubit(this.repository, this.authCubit) : super(const ChatInitial()) {
    _loadCachedSessions();
  }

  Future<void> loadSessions() async {
    final userId = authCubit.currentUser?.id;
    if (userId == null) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: 'User not logged in'));
      return;
    }
    try {
      final sessions = await repository.getSessions(userId.toString());
      emit(ChatSuccess(
        sessions: sessions,
        currentSessionId: sessions.isNotEmpty ? sessions.last.id : null,
        isCreatingSession: false,
      ));
    } catch (e) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: e.toString()));
    }
  }

  Future<void> _loadCachedSessions() async {
    final cachedSessions = await CacheHelper.getSessions();
    if (cachedSessions.isNotEmpty) {
      emit(ChatSuccess(
        sessions: cachedSessions,
        currentSessionId: cachedSessions.last.id,
        isCreatingSession: false,
      ));
    }
  }

  @override
  void emit(ChatState state) {
    if (state is ChatSuccess) {
      CacheHelper.saveSessions(state.sessions);
    }
    super.emit(state);
  }

  void deleteSession(String sessionId) async {
    final userId = authCubit.currentUser?.id;
    if (userId == null) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: 'User not logged in'));
      return;
    }
    try {
      await repository.deleteSession(userId.toString(), sessionId);
      final updatedSessions =
          state.sessions.where((s) => s.id != sessionId).toList();
      final newCurrentSessionId =
          updatedSessions.isNotEmpty ? updatedSessions.last.id : null;
      emit(ChatSuccess(
          sessions: updatedSessions,
          currentSessionId: newCurrentSessionId,
          isCreatingSession: false));
    } catch (e) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: e.toString()));
    }
  }

  void renameSession(String sessionId, String newTitle) {
    final updatedSessions = state.sessions.map((session) {
      return session.id == sessionId
          ? session.copyWith(title: newTitle)
          : session;
    }).toList();
    emit(ChatSuccess(
        sessions: updatedSessions,
        currentSessionId: state.currentSessionId,
        isCreatingSession: false));
  }

  void setCurrentSession(String sessionId) {
    emit(ChatSuccess(
        sessions: state.sessions,
        currentSessionId: sessionId,
        isCreatingSession: false));
  }

  void deleteMessage(Message message) {
    final updatedSessions = state.sessions.map((session) {
      return session.id == state.currentSessionId
          ? session.copyWith(
              messages: session.messages.where((m) => m != message).toList())
          : session;
    }).toList();
    emit(ChatSuccess(
        sessions: updatedSessions,
        currentSessionId: state.currentSessionId,
        isCreatingSession: false));
  }

  void addPendingMessage(String text) {
    final currentSession = _getCurrentSession();
    final newMessage = Message(
      text: text,
      isSentByMe: true,
      status: MessageStatus.pending,
      timestamp: DateTime.now(),
      sessionId: currentSession.id,
    );
    _pendingMessages.add(newMessage);
    final updatedSession = currentSession
        .copyWith(messages: [...currentSession.messages, newMessage]);
    emit(ChatSuccess(
        sessions: _updateSessions(updatedSession),
        currentSessionId: currentSession.id,
        isCreatingSession: false));
  }

  Future<void> sendTextMessage(String text) async {
    final userId = authCubit.currentUser?.id;
    if (userId == null) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: 'User not logged in'));
      return;
    }
    final currentSession = _getCurrentSession();
    final updatedSession = currentSession.copyWith(messages: [
      ...currentSession.messages,
      Message(
          text: text,
          isSentByMe: true,
          status: MessageStatus.pending,
          timestamp: DateTime.now())
    ]);
    final updatedSessions = _updateSessions(updatedSession);
    emit(ChatLoading(
        sessions: updatedSessions, currentSessionId: currentSession.id));
    try {
      final response = await repository.sendText(ChatRequestBody(
        query: text,
        userId: userId.toString(),
        sessionId: currentSession.id,
      ));
      _handleSuccessResponse(updatedSession, response.answer);
    } catch (e) {
      emit(ChatSuccess(
          sessions: updatedSessions,
          currentSessionId: currentSession.id,
          isCreatingSession: false));
      if (e is NetworkUnavailableException) {
        _pendingMessages.add(Message(
          text: text,
          isSentByMe: true,
          status: MessageStatus.pending,
          timestamp: DateTime.now(),
        ));
      }
    }
  }

  Future<ChatSession> createNewSession() async {
    final userId = authCubit.currentUser?.id;
    if (userId == null) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: 'User not logged in'));
      return ChatSession(
        id: 'default_${DateTime.now().millisecondsSinceEpoch}',
        messages: [],
        createdAt: DateTime.now(),
      );
    }
    emit(ChatSuccess(
        sessions: state.sessions,
        currentSessionId: state.currentSessionId,
        isCreatingSession: true));
    try {
      final response = await repository.createNewSession(userId.toString());
      final newSession = ChatSession(
        id: response.sessionId,
        messages: [],
        createdAt: DateTime.now(),
      );
      _addNewSession(newSession);
      return newSession;
    } catch (e) {
      final localSessionId = 'local_${DateTime.now().millisecondsSinceEpoch}';
      final newSession = ChatSession(
        id: localSessionId,
        messages: [],
        createdAt: DateTime.now(),
      );
      _addNewSession(newSession);
      return newSession;
    }
  }

  void _addNewSession(ChatSession newSession) {
    final newSessions = [...state.sessions, newSession];
    emit(ChatSuccess(
        sessions: newSessions,
        currentSessionId: newSession.id,
        isCreatingSession: false));
  }

  Future<void> sendImageMessage(
      File image, String question, String mode, String speak) async {
    final userId = authCubit.currentUser?.id;
    if (userId == null) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: 'User not logged in'));
      return;
    }
    final currentSession = _getCurrentSession();
    final sessionId = currentSession.id;
    final updatedSession = currentSession.copyWith(messages: [
      ...currentSession.messages,
      Message(
          text: question,
          isSentByMe: true,
          imageUrl: image.path,
          status: MessageStatus.pending)
    ]);
    final updatedSessions = _updateSessions(updatedSession);
    emit(ChatLoading(
        sessions: updatedSessions, currentSessionId: currentSession.id));
    try {
      final response = await repository.sendImage(
          image, question, mode, speak, sessionId, userId.toString());
      _handleSuccessResponse(updatedSession, response.answer);
    } catch (e) {
      _handleError(e, updatedSessions, currentSession, question, file: image);
    }
  }

  Future<void> sendVoiceMessage(File voiceFile,
      {String speak = 'true', String language = 'auto'}) async {
    final userId = authCubit.currentUser?.id;
    if (userId == null) {
      emit(ChatError(
          sessions: state.sessions,
          currentSessionId: state.currentSessionId,
          error: 'User not logged in'));
      return;
    }

    final currentSession = _getCurrentSession();
    final sessionId = currentSession.id;
    final updatedSession = currentSession.copyWith(messages: [
      ...currentSession.messages,
      Message(
          text: '',
          isSentByMe: true,
          voiceFilePath: voiceFile.path,
          status: MessageStatus.pending)
    ]);
    final updatedSessions = _updateSessions(updatedSession);
    emit(ChatLoading(
        sessions: updatedSessions, currentSessionId: currentSession.id));
    try {
      final response = await repository.sendVoice(
        voiceFile,
        speak,
        language,
        userId.toString(),
        sessionId,
      );
      _handleSuccessResponse(updatedSession, response.answer);
    } catch (e) {
      _handleError(e, updatedSessions, currentSession, '', file: voiceFile);
    }
  }

  ChatSession _getCurrentSession() {
    if (state.sessions.isEmpty) {
      final newSession = ChatSession(
        id: 'default_${DateTime.now().millisecondsSinceEpoch}',
        messages: [],
        createdAt: DateTime.now(),
      );
      emit(ChatSuccess(
          sessions: [newSession],
          currentSessionId: newSession.id,
          isCreatingSession: false));
      return newSession;
    }
    return state.sessions.firstWhere(
      (s) => s.id == state.currentSessionId,
      orElse: () => state.sessions.last,
    );
  }

  void _handleSuccessResponse(ChatSession session, String answer) {
    final finalSession = session.copyWith(messages: [
      ...session.messages,
      Message(text: answer, isSentByMe: false, status: MessageStatus.delivered)
    ]);
    emit(ChatSuccess(
        sessions: _updateSessions(finalSession),
        currentSessionId: session.id,
        isCreatingSession: false));
  }

  void _handleError(dynamic error, List<ChatSession> sessions,
      ChatSession session, String text,
      {File? file}) {
    if (error is NetworkUnavailableException) {
      _pendingMessages.add(Message(
        text: text,
        isSentByMe: true,
        status: MessageStatus.pending,
        imageUrl: file?.path,
        voiceFilePath: file?.path,
      ));
      emit(ChatNetworkError(
        sessions: sessions,
        currentSessionId: session.id,
        error: error.toString(),
        lastMessage: text,
        pendingMessages: _pendingMessages,
      ));
    } else {
      emit(ChatError(
        sessions: sessions,
        currentSessionId: session.id,
        error: error.toString(),
      ));
    }
  }

  void addBotMessage(String message, String sessionId) {
    final botMessage = Message(
      text: message,
      isSentByMe: false,
      status: MessageStatus.delivered,
      timestamp: DateTime.now(),
      sessionId: sessionId,
    );

    final updatedSessions = state.sessions.map((session) {
      if (session.id == sessionId) {
        return session.copyWith(messages: [...session.messages, botMessage]);
      }
      return session;
    }).toList();

    emit(ChatSuccess(
      sessions: updatedSessions,
      currentSessionId: sessionId,
      isCreatingSession: false,
    ));
  }

  void retryPendingMessages() {
    if (state is! ChatNetworkError) return;
    final pendingCopy = List<Message>.from(_pendingMessages);
    _pendingMessages.clear();
    final currentMessages = _getCurrentSession().messages;
    pendingCopy.removeWhere((msg) => currentMessages.contains(msg));
    for (final message in pendingCopy) {
      if (message.imageUrl != null) {
        sendImageMessage(
            File(message.imageUrl!), message.text, 'text', 'false');
      } else if (message.voiceFilePath != null) {
        sendVoiceMessage(File(message.voiceFilePath!));
      } else {
        sendTextMessage(message.text);
      }
    }
  }

  List<ChatSession> _updateSessions(ChatSession updatedSession) {
    return state.sessions
        .map((s) => s.id == updatedSession.id ? updatedSession : s)
        .toList();
  }
}
