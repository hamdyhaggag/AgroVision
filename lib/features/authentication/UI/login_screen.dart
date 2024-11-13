import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/features/home/Ui/screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/functions.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/emai_and_password.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 110.h),
                Image.asset(
                  'assets/images/authentication/logo4login.png',
                  height: 250.h,
                  width: 250.w,
                ),
                SizedBox(height: 40.h),
                const EmailAndPassword(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColors.primaryColor,
                          value: _rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() => _rememberMe = newValue ?? false);
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.forgotPasswordPhone);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomBottom(
                  text: 'Log In',
                  onPressed: () {
                    navigateAndFinish(context, const ScreenLayout());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
