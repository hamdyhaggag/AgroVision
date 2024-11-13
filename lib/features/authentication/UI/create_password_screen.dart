import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/helpers/app_regexp.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/themes/app_colors.dart';
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
      appBar: const CustomAppBar(title: 'Create New Password'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: SvgPicture.asset(
                        'assets/images/authentication/Create_New_Password.svg'),
                  ),
                  Center(
                    child: Text(
                      'New password must be\ndifferent from the last password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  buildPasswordSection(),
                  SizedBox(height: 12.h),
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
        ),
      ),
    );
  }

  Widget buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Password',
            style: TextStyle(
              color: const Color(0xFF001640),
              fontSize: 12.sp,
              fontFamily: 'DIN',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomTextField(
          controller: passwordController,
          hintText: 'Password',
          isObscureText: isPasswordObscureText,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            size: 18.sp,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordObscureText = !isPasswordObscureText;
              });
            },
            child: Icon(
              isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid password';
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            'Confirm Password',
            style: TextStyle(
              color: const Color(0xFF001640),
              fontSize: 12.sp,
              fontFamily: 'DIN',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomTextField(
          controller: passwordConfirmationController,
          hintText: 'Confirm Password',
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            size: 18.sp,
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
    );
  }

  void validateThenDoNewPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String? email = widget.email;
      if (kDebugMode) {
        print('Email: $email');
      }

      Navigator.pushNamed(context, AppRoutes.congratulationsScreen);
    }
  }
}
