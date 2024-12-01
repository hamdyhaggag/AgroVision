import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../../core/network/api_service.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../authentication/Logic/logout cubit/logout_cubit.dart';
import '../../authentication/Logic/logout cubit/logout_state.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(ApiService(Dio())),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logout.svg',
                  height: 400.h,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 20.h),
                BlocListener<LogoutCubit, LogoutState>(
                  listener: (context, state) {
                    if (state is LogoutSuccess) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.loginScreen);
                    } else if (state is LogoutError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      CustomBottom(
                        text: 'Yes, Log Out',
                        onPressed: () {
                          context.read<LogoutCubit>().logout();
                        },
                      ),
                      SizedBox(height: 10.h),
                      CustomBottom(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
