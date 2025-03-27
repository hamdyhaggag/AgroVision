// cache_helper.dart
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agro_vision/models/chat_message.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static const String _chatMessagesKey = 'chat_messages';

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    log("saving >>> $value into local >>> with key $key");
    if (value is String) await sharedPreferences!.setString(key, value);
    if (value is int) await sharedPreferences!.setInt(key, value);
    if (value is double) await sharedPreferences!.setDouble(key, value);
    if (value is bool) await sharedPreferences!.setBool(key, value);
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

  static String getString({required String key}) =>
      sharedPreferences!.getString(key) ?? "";
  static int getInteger({required String key}) =>
      sharedPreferences!.getInt(key) ?? 0;
  static bool getBoolean({required String key}) =>
      sharedPreferences!.getBool(key) ?? false;

  static Future<bool> removeData({required String key}) async =>
      await sharedPreferences!.remove(key);
}
