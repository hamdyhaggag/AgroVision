import 'package:agro_vision/features/authentication/UI/otp/otp_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/helpers/app_regexp.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_botton.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class ForgotPasswordEmail extends StatefulWidget {
  const ForgotPasswordEmail({super.key});

  @override
  State<ForgotPasswordEmail> createState() => _ForgotPasswordEmailState();
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  late TextEditingController emailController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Forgot Password'),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SvgPicture.asset(
                    'assets/images/authentication/Forgot_Password_With_Email.svg',
                  ),
                ),
                Text(
                  'Please enter your email address to\n        receive a verification code',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.navy,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: CustomTextField(
                    controller: emailController,
                    hintText: 'You@gmail.com',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: 18.sp,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !AppRegex.isEmailValid(value)) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                CustomBottom(
                  text: 'Send Code',
                  onPressed: () {
                    validateThenDoForgot();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoForgot() {
    if (formKey.currentState!.validate()) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return OtpEmailScreen(
          email: emailController.text,
        );
      }));
    }
  }
}
