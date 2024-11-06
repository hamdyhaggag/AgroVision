import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/themes/app_colors.dart';
import 'core/utils/utils.dart';

class AgroVision extends StatelessWidget {
  final AppRouter appRouter;
  const AgroVision({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'AgroVision',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: Colors.white,
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
        // localizationsDelegates: context.localizationDelegates,
        // supportedLocales: context.supportedLocales,
        // locale: context.locale,
      ),
    );
  }
}
