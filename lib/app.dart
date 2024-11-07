import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/themes/app_colors.dart';
import 'core/utils/utils.dart';
import 'cubit/app_cubit/app_cubit.dart';
import 'cubit/app_cubit/app_state.dart';

class AgroVision extends StatelessWidget {
  final AppRouter appRouter;

  const AgroVision({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return MaterialApp(
              title: 'AgroVision',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: AppColors.primaryColor,
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
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            );
          },
        ),
      ),
    );
  }
}
