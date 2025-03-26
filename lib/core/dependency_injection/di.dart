import 'package:get_it/get_it.dart';
import '../../features/authentication/Data/repos/login_repo.dart';
import '../../features/authentication/Logic/login cubit/login_cubit.dart';
import '../../features/authentication/Logic/logout cubit/logout_cubit.dart';
import '../../features/chat/Logic/chat_cubit.dart';
import '../../features/chat/api/chatbot_service.dart';
import '../../features/chat/chat_repository.dart';
import '../network/api_service.dart';
import '../network/dio_factory.dart';

final getIt = GetIt.instance;

// lib/core/dependency_injection/di.dart
Future<void> setupGetIt() async {
  // Main Dio instances
  final dio = DioFactory.getDio();
  final chatDio = DioFactory.getChatDio();

  // Register services
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton<ChatbotService>(() => ChatbotService(chatDio));

  // Register repositories
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepository(chatbotService: getIt<ChatbotService>()),
  );

  // Authentication
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<LogoutCubit>(() => LogoutCubit(getIt()));

  // Add this line if using MultiBlocProvider
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepository>()));
}
