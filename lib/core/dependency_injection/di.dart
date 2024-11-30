import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/Data/repos/login_repo.dart';
import '../../features/authentication/Logic/login_cubit.dart';
import '../network/api_service.dart';
import '../network/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
}
