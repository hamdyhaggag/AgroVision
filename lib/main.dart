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
import 'core/routing/app_router.dart';
import 'bloc_observer_checker.dart';

bool isEnterBefore = false;

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await initializeAppSettings();
  await setupGetIt();

  Bloc.observer = const BlocObserverChecker();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    EasyLocalization(
      supportedLocales: AppLocalizations.supportedLocales,
      fallbackLocale: AppLocalizations.english,
      path: AppLocalizations.translationsPath,
      startLocale: AppLocalizations.english,
      saveLocale: true,
      child: AgroVision(appRouter: AppRouter()),
    ),
  );
}

Future<void> initializeAppSettings() async {
  isEnterBefore = CacheHelper.getBoolean(key: 'isEnterBefore');
}
