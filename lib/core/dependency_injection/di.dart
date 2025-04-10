import 'package:get_it/get_it.dart';
import '../../features/authentication/Data/repos/login_repo.dart';
import '../../features/authentication/Logic/login cubit/login_cubit.dart';
import '../../features/authentication/Logic/logout cubit/logout_cubit.dart';
import '../../features/authentication/Logic/services/auth_service.dart';
import '../../features/authentication/Logic/services/session_service.dart';
import '../../features/authentication/Logic/services/settings_service.dart';
import '../../features/chat/Logic/chat_cubit.dart';
import '../../features/chat/api/chatbot_service.dart';
import '../../features/chat/chat_repository.dart';
import '../network/api_service.dart';
import '../network/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Main Dio instances
  final dio = DioFactory.getDio();
  final chatDio = DioFactory.getChatDio();

  // Register services
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton<ChatbotService>(() => ChatbotService(chatDio));

  // Add these FIRST before ChatRepository
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<SessionService>(() => SessionService());
  getIt.registerLazySingleton<SettingsService>(() => SettingsService());

  // Correct ChatRepository registration (remove the duplicate)
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepository(
      chatbotService: getIt<ChatbotService>(),
      authService: getIt<AuthService>(),
      sessionService: getIt<SessionService>(),
      settingsService: getIt<SettingsService>(),
    ),
  );

  // Authentication
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<LogoutCubit>(() => LogoutCubit(getIt()));

  // Chat Cubit
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepository>()));
}
