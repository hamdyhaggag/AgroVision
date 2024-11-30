import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/features/home/Ui/screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/validations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/functions.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/custom_text_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? emailError;
  String? passwordError;

  bool _rememberMe = false;
  bool isPasswordObscureText = true;

  void validateFields() {
    setState(() {
      emailError = Validations.validateEmail(emailController.text);
      passwordError = Validations.validatePassword(passwordController.text);
    });

    if (emailError == null && passwordError == null) {
      // If no errors, proceed to login
      navigateAndFinish(context, const ScreenLayout());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, size: 18.sp),
                    validator: Validations.validateEmail,
                    errorMessage: emailError,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    isObscureText: isPasswordObscureText,
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 18.sp),
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
                    validator: Validations.validatePassword,
                    errorMessage: passwordError,
                  ),
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
                    onPressed: validateFields,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
