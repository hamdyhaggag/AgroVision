import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/dependency_injection/di.dart';
import 'core/helpers/cache_helper.dart';
import 'core/helpers/location_helper.dart';
import 'core/network/api_service.dart';
import 'core/network/dio_factory.dart';
import 'core/network/weather_service.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/theme_cubit/theme_cubit.dart';
import 'core/themes/app_colors.dart';
import 'core/utils/utils.dart';
import 'features/authentication/Logic/auth cubit/auth_cubit.dart';
import 'features/authentication/Logic/login cubit/login_cubit.dart';
import 'features/authentication/Logic/logout cubit/logout_cubit.dart';
import 'features/chat/chat_repository.dart';
import 'features/chat/logic/chat_cubit.dart';
import 'features/chat/logic/farmer_chat_cubit.dart';
import 'features/chat/services/farmer_chat_api_service.dart';
import 'features/disease_detection/Api/disease_detection_service.dart';
import 'features/disease_detection/Logic/disease_cubit.dart';
import 'features/home/Api/orders_repo.dart';
import 'features/home/Api/sensor_service.dart';
import 'features/home/Logic/home_cubit/home_cubit.dart';
import 'features/home/Logic/orders_cubit/orders_cubit.dart';
import 'features/home/Logic/task_cubit/task_cubit.dart';
import 'features/monitoring/Api/sensor_data_service.dart';
import 'features/monitoring/Logic/sensor_data_cubit.dart';
import 'package:provider/provider.dart';
import 'features/notifications/cubit/unified_notification_cubit.dart';
import 'features/notifications/services/unified_notification_service.dart';

import 'features/monitoring/notification/notification_cubit/notification_cubit.dart';

class AgroVision extends StatelessWidget {
  final AppRouter appRouter;
  final SensorDataService _sensorDataService =
      SensorDataService(DioFactory.getDio());

  AgroVision({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => AuthCubit(),
            ),
            BlocProvider(
              create: (BuildContext context) => LoginCubit(getIt()),
            ),
            BlocProvider(
              create: (BuildContext context) => LogoutCubit(getIt()),
            ),
            BlocProvider(
              create: (_) => SensorDataCubit(_sensorDataService),
            ),
            BlocProvider(
              create: (context) =>
                  DiseaseDetectionCubit(DiseaseDetectionService()),
            ),
            BlocProvider(
              create: (context) => HomeCubit(
                weatherService: WeatherService(),
                locationHelper: LocationHelper(),
                sensorService: SensorService(Dio()),
              ),
            ),
            BlocProvider(
                create: (context) =>
                    ChatCubit(getIt<ChatRepository>(), AuthCubit())),
            BlocProvider(
              create: (context) => TaskCubit(),
            ),
            BlocProvider(
              create: (context) => NotificationCubit(context.read<AuthCubit>()),
            ),
            BlocProvider(
              create: (context) => ThemeCubit()..getCurrentTheme(),
            ),
            BlocProvider(
              create: (context) => UnifiedNotificationCubit(
                UnifiedNotificationService(),
              )..loadNotifications(),
            ),
            Provider<FarmerChatApiService>(
              create: (context) =>
                  FarmerChatApiService(DioFactory.getAgrovisionDio()),
            ),
            BlocProvider<FarmerChatCubit>(
              create: (context) => FarmerChatCubit(
                context.read<FarmerChatApiService>(),
              )..loadConversations(),
            ),
            BlocProvider(
              create: (context) => OrdersCubit(
                  OrdersRepo(ApiService(DioFactory.getAgrovisionDio())))
                ..fetchOrders(),
            ),
          ],
          child: MaterialApp(
            title: 'AgroVision',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: context.locale.languageCode == 'ar' ? 'DIN' : 'SYNE',
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryColor,
              ),
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: Colors.white,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.primaryColor,
                selectionColor: AppColors.primaryColor,
                selectionHandleColor: AppColors.primaryColor,
              ),
            ),
            navigatorKey: AppRouter.navigatorKey,
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: AppRoutes.splashScreen,
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQueryData.copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: GestureDetector(
                  onTap: () => Utils.closeKeyboard,
                  child: child ?? const SizedBox(),
                ),
              );
            },
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        ));
  }
}
