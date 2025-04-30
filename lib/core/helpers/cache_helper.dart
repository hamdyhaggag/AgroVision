import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/models/chat_message.dart';
import '../../models/chat_session.dart';
import '../../models/notification_model.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static const String _chatMessagesKey = 'chat_messages';
  static const _sessionsKey = 'chat_sessions';

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> ensureInitialized() async {
    if (sharedPreferences == null) {
      await init();
    }
  }

  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    await ensureInitialized();
    if (value is String) {
      await sharedPreferences!.setString(key, value);
      if (kDebugMode) {
        print('💾 SAVED $key: $value');
      }
    }
    log("saving >>> $value into local >>> with key $key");
    if (value is String) await sharedPreferences!.setString(key, value);
    if (value is int) await sharedPreferences!.setInt(key, value);
    if (value is double) await sharedPreferences!.setDouble(key, value);
    if (value is bool) await sharedPreferences!.setBool(key, value);
  }

  static Future<void> saveAudioFilePath(
      String audioUrl, String localPath) async {
    await ensureInitialized();
    final key = 'audio_$audioUrl';
    await sharedPreferences!.setString(key, localPath);
    if (kDebugMode) {
      print('💾 Cached audio path for $audioUrl at $localPath');
    }
  }

  static String getAudioFilePath(String audioUrl) {
    ensureInitialized();
    final key = 'audio_$audioUrl';
    final path = sharedPreferences!.getString(key) ?? '';
    if (kDebugMode) {
      print(
          '🔑 Retrieved audio path for $audioUrl: ${path.isEmpty ? '[not cached]' : path}');
    }
    return path;
  }

  static String getString({required String key}) {
    if (sharedPreferences == null) {
      if (kDebugMode) {
        print('⚠️ SharedPreferences not initialized!');
      }
      return '';
    }
    final value = sharedPreferences!.getString(key) ?? '';
    if (kDebugMode) {
      print('🔑 Retrieved $key: ${value.isEmpty ? '[empty]' : value}');
    }
    return value;
  }

  static Future<void> saveMessages(List<Message> messages) async {
    final jsonList = messages.map((msg) => msg.toJson()).toList();
    await saveData(
      key: _chatMessagesKey,
      value: jsonEncode(jsonList),
    );
  }

  static List<Message> getMessages() {
    final jsonString = getString(key: _chatMessagesKey);
    if (jsonString.isEmpty) return [];
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList.map((json) => Message.fromJson(json)).toList();
  }

  static int getInt(String key) => sharedPreferences?.getInt(key) ?? -1;

  static int getInteger({required String key}) =>
      sharedPreferences!.getInt(key) ?? 0;

  static bool getBoolean({required String key}) =>
      sharedPreferences!.getBool(key) ?? false;

  static Future<bool> removeData({required String key}) async =>
      await sharedPreferences!.remove(key);

  static Future<List<ChatSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList(_sessionsKey) ?? [];
    return sessionsJson
        .map((json) => ChatSession.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson =
        sessions.map((session) => jsonEncode(session.toJson())).toList();
    prefs.setStringList(_sessionsKey, sessionsJson);
  }

  void logout() {
    CacheHelper.saveData(key: 'isLoggedIn', value: false);
    CacheHelper.removeData(key: 'token');
  }

  static Future<void> saveProfileImage(String imagePath) async {
    await saveData(key: 'profileImage', value: imagePath);
  }

  static String getStringg(String key) =>
      sharedPreferences?.getString(key) ?? '';

  static Future<String> getProfileImage() async {
    await ensureInitialized();
    return sharedPreferences!.getString('profileImage') ?? '';
  }

  static final ValueNotifier<String> profileImageNotifier =
      ValueNotifier<String>('');

  static setBool(String key, bool value) {
    sharedPreferences?.setBool(key, value);
  }

  static bool getBool(String key) {
    return sharedPreferences?.getBool(key) ?? false;
  }

  static const String _notificationsKey = 'notifications';

  static Future<void> saveNotifications(
      List<NotificationModel> notifications) async {
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await saveData(
      key: _notificationsKey,
      value: jsonEncode(jsonList),
    );
  }

  static List<NotificationModel> getNotifications() {
    final jsonString = getString(key: _notificationsKey);
    if (jsonString.isEmpty) return [];
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }
}
