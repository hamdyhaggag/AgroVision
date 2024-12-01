import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/helpers/app_regexp.dart';
import '../../features/authentication/Logic/login cubit/login_cubit.dart';
import 'custom_text_field.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  bool isPasswordObscureText = true;

  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    passwordController = context.read<LoginCubit>().passwordController;
    // setupPasswordControllerListener();
  }

  // void setupPasswordControllerListener() {
  //   passwordController.addListener(() {
  //     setState(() {
  //       hasLowercase = AppRegex.hasLowerCase(passwordController.text);
  //       hasNumber = AppRegex.hasNumber(passwordController.text);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: context.read<LoginCubit>().formKey,
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Username or Email',
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 18.sp,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email address';
                }
                if (!value.contains('@')) {
                  return 'Email must contain "@"';
                }
                if (!value.contains('.') ||
                    value.indexOf('.') < value.indexOf('@')) {
                  return 'Email must have a valid domain (e.g., ".com")';
                }
                if (!AppRegex.isEmailValid(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              controller: context.read<LoginCubit>().emailController,
            ),
            SizedBox(
              height: 12.h,
            ),
            CustomTextField(
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
                  return 'Please enter a password';
                }
                if (!AppRegex.hasLowerCase(value)) {
                  return 'Password must contain at least one lowercase letter';
                }
                if (!AppRegex.hasUpperCase(value)) {
                  return 'Password must contain at least one uppercase letter';
                }
                if (!AppRegex.hasNumber(value)) {
                  return 'Password must contain at least one number';
                }
                if (!AppRegex.hasSpecialCharacter(value)) {
                  return 'must contain at least one special character (@, #, !, etc.)';
                }
                if (!AppRegex.hasMinLength(value)) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              controller: context.read<LoginCubit>().passwordController,
            ),
          ],
        ));
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
