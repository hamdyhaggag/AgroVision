import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/dependency_injection/di.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/themes/app_colors.dart';
import 'core/utils/utils.dart';
import 'features/authentication/Logic/auth cubit/auth_cubit.dart';
import 'features/authentication/Logic/login cubit/login_cubit.dart';
import 'features/authentication/Logic/logout cubit/logout_cubit.dart';

class AgroVision extends StatelessWidget {
  final AppRouter appRouter;

  const AgroVision({super.key, required this.appRouter});

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
          ],
          child: MaterialApp(
            title: 'AgroVision',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
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
              return GestureDetector(
                onTap: () => Utils.closeKeyboard,
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
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
