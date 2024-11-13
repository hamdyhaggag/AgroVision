import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_botton.dart';

class OtpPhoneScreen extends StatefulWidget {
  const OtpPhoneScreen({super.key});

  @override
  State<OtpPhoneScreen> createState() => _OtpPhoneScreenState();
}

class _OtpPhoneScreenState extends State<OtpPhoneScreen> {
  int _start = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _start = 45;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verification code'),
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/authentication/Otp_With_Phone.svg',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Please enter the 4 digit code\n    sent to: ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navy,
                          ),
                        ),
                        TextSpan(
                          text: '+20 1234567890',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: OtpTextField(
                numberOfFields: 4,
                borderColor: AppColors.navy,
                autoFocus: true,
                focusedBorderColor: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
                fieldWidth: 64.w,
                cursorColor: AppColors.primaryColor,
                showFieldAsBox: true,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    },
                  );
                },
              ),
            ),
            CustomBottom(
              text: 'Verify Code',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createNewPassword);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '00:${_start.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
            GestureDetector(
              onTap: resetTimer,
              child: Text(
                'Resend Code',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
