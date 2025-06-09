import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'core/dependency_injection/di.dart';
import 'core/helpers/app_localizations.dart';
import 'core/helpers/cache_helper.dart';
import 'core/network/api_service.dart';
import 'core/network/dio_factory.dart';
import 'core/routing/app_router.dart';
import 'bloc_observer_checker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:agro_vision/shared/services/notification_service.dart';

bool isEnterBefore = false;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await initializeAppSettings();
  await NotificationService().initialize();
  await setupGetIt();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      // Handle notification taps
    },
  );
  Bloc.observer = const BlocObserverChecker();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiService>(
          create: (_) => ApiService(DioFactory.getDio()),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: AppLocalizations.supportedLocales,
        fallbackLocale: AppLocalizations.english,
        path: AppLocalizations.translationsPath,
        startLocale: AppLocalizations.english,
        saveLocale: true,
        child: AgroVision(appRouter: AppRouter()),
      ),
    ),
  );
}

Future<void> initializeAppSettings() async {
  isEnterBefore = CacheHelper.getBoolean(key: 'isEnterBefore');
}
