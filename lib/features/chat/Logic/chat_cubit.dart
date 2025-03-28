import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/helpers/cache_helper.dart';
import '../../../models/chat_message.dart';
import '../../../models/chat_session.dart';
import '../chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

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
    if (state is ChatSuccess) CacheHelper.saveSessions(state.sessions);
    super.emit(state);
  }

  void createNewSession() {
    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      messages: [],
      createdAt: DateTime.now(),
    );
    emit(ChatSuccess(
      sessions: [...state.sessions, newSession],
      currentSessionId: newSession.id,
    ));
  }

  void deleteSession(String sessionId) {
    final updatedSessions =
        state.sessions.where((s) => s.id != sessionId).toList();
    final newCurrentSessionId =
        updatedSessions.isNotEmpty ? updatedSessions.last.id : null;

    emit(ChatSuccess(
      sessions: updatedSessions,
      currentSessionId: newCurrentSessionId,
    ));
  }

  void renameSession(String sessionId, String newTitle) {
    final updatedSessions = state.sessions.map((session) {
      if (session.id == sessionId) {
        return session.copyWith(title: newTitle);
      }
      return session;
    }).toList();

    emit(ChatSuccess(
      sessions: updatedSessions,
      currentSessionId: state.currentSessionId,
    ));
  }

  void setCurrentSession(String sessionId) {
    emit(ChatSuccess(
      sessions: state.sessions,
      currentSessionId: sessionId,
    ));
  }

  void deleteMessage(Message message) {
    final updatedSessions = state.sessions.map((session) {
      if (session.id == state.currentSessionId) {
        return session.copyWith(
          messages: session.messages.where((m) => m != message).toList(),
        );
      }
      return session;
    }).toList();

    emit(ChatSuccess(
      sessions: updatedSessions,
      currentSessionId: state.currentSessionId,
    ));
  }

  Future<void> sendTextMessage(String text) async {
    final currentSession = state.sessions.firstWhere(
      (s) => s.id == state.currentSessionId,
      orElse: () => state.sessions.last,
    );

    var updatedSession = currentSession.copyWith(
      messages: [
        ...currentSession.messages,
        Message(text: text, isSentByMe: true)
      ],
    );

    if (updatedSession.title == null) {
      final userMessages = updatedSession.messages.where((m) => m.isSentByMe);
      if (userMessages.isNotEmpty) {
        updatedSession = updatedSession.copyWith(
          title: userMessages.first.text,
        );
      }
    }

    final updatedSessions = _updateSessions(updatedSession);

    emit(ChatLoading(
      sessions: updatedSessions,
      currentSessionId: currentSession.id,
    ));

    try {
      final response = await repository.sendText(text);
      final finalSession = updatedSession.copyWith(messages: [
        ...updatedSession.messages,
        Message(text: response.answer, isSentByMe: false)
      ]);
      emit(ChatSuccess(
        sessions: _updateSessions(finalSession),
        currentSessionId: currentSession.id,
      ));
    } catch (e) {
      emit(ChatError(
        sessions: updatedSessions,
        currentSessionId: currentSession.id,
        error: e.toString(),
      ));
    }
  }

  Future<void> sendImageMessage(
    File image,
    String question,
    String mode,
    String speak,
  ) async {
    final currentSession = state.sessions.firstWhere(
      (s) => s.id == state.currentSessionId,
      orElse: () => state.sessions.last,
    );

    var updatedSession = currentSession.copyWith(
      messages: [
        ...currentSession.messages,
        Message(
          text: question,
          isSentByMe: true,
          imageUrl: image.path,
        ),
      ],
    );

    final updatedSessions = _updateSessions(updatedSession);

    emit(ChatLoading(
      sessions: updatedSessions,
      currentSessionId: currentSession.id,
    ));

    try {
      final response =
          await repository.sendImage(image, question, 'text', 'false');

      final finalSession = updatedSession.copyWith(messages: [
        ...updatedSession.messages,
        Message(text: response.answer, isSentByMe: false)
      ]);

      emit(ChatSuccess(
        sessions: _updateSessions(finalSession),
        currentSessionId: currentSession.id,
      ));
    } catch (e) {
      emit(ChatError(
        sessions: updatedSessions,
        currentSessionId: currentSession.id,
        error: e.toString(),
      ));
    }
  }

  List<ChatSession> _updateSessions(ChatSession updatedSession) {
    return state.sessions
        .map((s) => s.id == updatedSession.id ? updatedSession : s)
        .toList();
  }

  Future<void> sendVoiceMessage(File voiceFile,
      {String speak = 'false', String language = 'en'}) async {
    final currentSession = state.sessions.firstWhere(
      (s) => s.id == state.currentSessionId,
      orElse: () => state.sessions.last,
    );

    // 1) Add a message with the local voice file path so the UI can play it.
    var updatedSession = currentSession.copyWith(
      messages: [
        ...currentSession.messages,
        Message(
          text: '',
          isSentByMe: true,
          voiceFilePath: voiceFile.path, // Now this is a named parameter
        ),
      ],
    );

    final updatedSessions = _updateSessions(updatedSession);
    emit(ChatLoading(
      sessions: updatedSessions,
      currentSessionId: currentSession.id,
    ));

    try {
      // 2) Send the voice file to the server
      final response = await repository.sendVoice(voiceFile, speak, language);

      // 3) Append the server’s response to the chat
      final finalSession = updatedSession.copyWith(
        messages: [
          ...updatedSession.messages,
          Message(
            text: response.answer,
            isSentByMe: false,
          ),
        ],
      );

      emit(ChatSuccess(
        sessions: _updateSessions(finalSession),
        currentSessionId: currentSession.id,
      ));
    } catch (e) {
      emit(ChatError(
        sessions: updatedSessions,
        currentSessionId: currentSession.id,
        error: e.toString(),
      ));
    }
  }
}
