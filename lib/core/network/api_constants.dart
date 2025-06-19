import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.env['AGROVISION_API_BASE_URL'] ??
      'https://final.agrovision.ltd/api/';
  static String get farmerChatBaseUrl =>
      dotenv.env['AGROVISION_CHAT_BASE_URL'] ?? 'http://final.agrovision.ltd/';
  static String get openWeatherBaseUrl =>
      dotenv.env['OPENWEATHER_API_BASE_URL'] ??
      'https://api.openweathermap.org/data/2.5';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String firebaseRetrieve = 'firebase/retrieve';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
