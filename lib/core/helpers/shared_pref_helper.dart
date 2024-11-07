import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  //===============================================================

  static saveData({
    required String key,
    required dynamic value,
  }) async {
    log("saving >>> $value into local >>> with key $key");

    if (value is String) {
      sharedPreferences!.setString(key, value);
    }
    if (value is int) {
      sharedPreferences!.setInt(key, value);
    }
    if (value is double) {
      sharedPreferences!.setDouble(key, value);
    }
    if (value is bool) {
      sharedPreferences!.setBool(key, value);
    }
  }

  //===============================================================

  static String getString({required String key}) {
    return sharedPreferences!.getString(key) ?? "";
  }

  static int getInteger({required String key}) {
    return sharedPreferences!.getInt(key) ?? 0;
  }

  static bool getBoolean({required String key}) {
    return sharedPreferences!.getBool(key) ?? false;
  }

  //===============================================================

  static Future<bool> removeData({required String key}) async {
    //return await sharedPreferences!.clear();
    return await sharedPreferences!.remove(key);
  }
}

//===============================================================
