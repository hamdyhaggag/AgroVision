import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/helpers/app_regexp.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_botton.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class ForgotPasswordPhone extends StatefulWidget {
  const ForgotPasswordPhone({super.key});

  @override
  State<ForgotPasswordPhone> createState() => _ForgotPasswordPhoneState();
}

class _ForgotPasswordPhoneState extends State<ForgotPasswordPhone> {
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Forgot Password'),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: SvgPicture.asset(
                'assets/images/authentication/Forgot_Password_WithPhone.svg'),
          ),
          Text(
            'Please enter your phone address to\n        receive a verification code',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: CustomTextField(
                keyboardType: TextInputType.number,
                hintText: '01234567890',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 14, left: 16, bottom: 16),
                  child: FaIcon(
                    FontAwesomeIcons.mobileScreenButton,
                    size: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !AppRegex.isPhoneNumberValid(value)) {
                    return 'Please enter a valid phone number';
                  }
                }),
          ),
          CustomBottom(
              text: 'Send Code',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.otpPhoneScreen,
                );
              }),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.forgotPasswordEmail);
              },
              child: Text(
                'Try Another Way',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor),
              ))
        ],
      )),
    );
  }
}
