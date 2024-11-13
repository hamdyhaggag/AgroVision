import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/helpers/app_regexp.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_back_arrow_button.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/custom_text_field.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key, this.email});
  final String? email;

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  late String phoneNumber;

  bool isPasswordObscureText = true;
  bool isPasswordConfirmationObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();

    setupPasswordControllerListener();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: Row(
                  children: [
                    const CustomArrowBackBottom(),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SvgPicture.asset(
                    'assets/images/authentication/Create_New_Password.svg'),
              ),
              Text(
                '    New password must be\ndiffrent from last password',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Color(0xFF001640),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    isObscureText: isPasswordObscureText,
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordObscureText = !isPasswordObscureText;
                        });
                      },
                      child: Icon(
                        isPasswordObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                    },
                  ),
                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: Color(0xFF001640),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomTextField(
                    controller: passwordConfirmationController,
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                    ),
                    isObscureText: isPasswordConfirmationObscureText,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordConfirmationObscureText =
                              !isPasswordConfirmationObscureText;
                        });
                      },
                      child: Icon(
                        isPasswordConfirmationObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              CustomBottom(
                text: 'Save Password',
                onPressed: () {
                  validateThenDoNewPassword(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateThenDoNewPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Here, we're setting the email directly
      String? email = widget.email;
      if (kDebugMode) {
        print('Email: $email');
      } // Log for debugging purposes

      // Simulate password change logic
      // You can add your own logic for updating password here

      Navigator.pushNamed(context, AppRoutes.congratulationsScreen);
    }
  }
}
