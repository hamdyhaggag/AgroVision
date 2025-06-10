import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/helpers/app_regexp.dart';
import '../../features/authentication/Logic/login cubit/login_cubit.dart';
import 'custom_text_field.dart';

class EmailAndPasswordState extends State<EmailAndPassword> {
  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  bool isPasswordObscureText = true;

  late TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordController = context.read<LoginCubit>().passwordController;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Username or Email',
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 18.sp,
              ),
              validator: (value) {
                final trimmedValue = value?.trim() ?? '';

                if (trimmedValue.isEmpty) {
                  return 'Please enter an email address';
                }
                if (!trimmedValue.contains('@')) {
                  return 'Email must contain "@"';
                }
                if (!AppRegex.isEmailValid(trimmedValue)) {
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
                  return 'Password is required';
                }
                if (!AppRegex.hasMinLength(value)) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              controller: context.read<LoginCubit>().passwordController,
            ),
          ],
        ));
  }
}

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => EmailAndPasswordState();
}
