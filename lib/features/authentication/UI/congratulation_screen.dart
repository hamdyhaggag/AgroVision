import 'package:agro_vision/core/utils/functions.dart';
import 'package:agro_vision/features/authentication/UI/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_botton.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SvgPicture.asset(
                    'assets/images/authentication/Congratulations.svg'),
              ),
              Text(
                'Congratulations',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'You have updated the password. Please\nlogin again with your latest password',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
                textAlign: TextAlign.center, // Added textAlign
              ),
              SizedBox(height: 28.h),
              CustomBottom(
                text: 'Login',
                onPressed: () {
                  navigateAndFinish(context, const LogInScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
