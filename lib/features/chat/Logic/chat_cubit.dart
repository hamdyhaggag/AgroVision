import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/cache_helper.dart';
import '../../../models/chat_message.dart';
import '../../../models/chat_session.dart';
import '../chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final List<Message> _pendingMessages = [];
  List<Message> get pendingMessages => _pendingMessages;

  ChatCubit(this.repository) : super(const ChatInitial()) {
    _loadCachedSessions();
  }

  Future<void> _loadCachedSessions() async {
    final cachedSessions = await CacheHelper.getSessions();
    if (cachedSessions.isNotEmpty) {
      emit(ChatSuccess(
        sessions: cachedSessions,
        currentSessionId: cachedSessions.last.id,
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

  void deleteSession(String sessionId) {
    final updatedSessions =
        state.sessions.where((s) => s.id != sessionId).toList();
    final newCurrentSessionId =
        updatedSessions.isNotEmpty ? updatedSessions.last.id : null;
    emit(ChatSuccess(
        sessions: updatedSessions, currentSessionId: newCurrentSessionId));
  }

  void renameSession(String sessionId, String newTitle) {
    final updatedSessions = state.sessions.map((session) {
      return session.id == sessionId
          ? session.copyWith(title: newTitle)
          : session;
    }).toList();
    emit(ChatSuccess(
        sessions: updatedSessions, currentSessionId: state.currentSessionId));
  }

  void setCurrentSession(String sessionId) {
    emit(ChatSuccess(sessions: state.sessions, currentSessionId: sessionId));
  }

  void deleteMessage(Message message) {
    final updatedSessions = state.sessions.map((session) {
      return session.id == state.currentSessionId
          ? session.copyWith(
              messages: session.messages.where((m) => m != message).toList())
          : session;
    }).toList();
    emit(ChatSuccess(
        sessions: updatedSessions, currentSessionId: state.currentSessionId));
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
        currentSessionId: currentSession.id));
  }

  Future<void> sendTextMessage(String text) async {
    final currentSession = _getCurrentSession();
    const userId = "55";
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
        userId: userId,
        sessionId: currentSession.id,
      ));
      _handleSuccessResponse(updatedSession, response.answer);
    } catch (e) {
      emit(ChatSuccess(
          sessions: updatedSessions, currentSessionId: currentSession.id));
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
    try {
      final response = await repository.createNewSession("55");
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
    emit(ChatSuccess(sessions: newSessions, currentSessionId: newSession.id));
  }

  Future<void> sendImageMessage(
      File image, String question, String mode, String speak) async {
    final currentSession = _getCurrentSession();
    const userId = "55";
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
          image, question, mode, speak, sessionId, userId);
      _handleSuccessResponse(updatedSession, response.answer);
    } catch (e) {
      _handleError(e, updatedSessions, currentSession, question, file: image);
    }
  }

  Future<void> sendVoiceMessage(File voiceFile,
      {String speak = 'false', String language = 'en'}) async {
    final currentSession = _getCurrentSession();
    const userId = "55";
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
        userId,
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
      emit(
          ChatSuccess(sessions: [newSession], currentSessionId: newSession.id));
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
        sessions: _updateSessions(finalSession), currentSessionId: session.id));
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
