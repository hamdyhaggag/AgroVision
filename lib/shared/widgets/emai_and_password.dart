import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/helpers/app_regexp.dart';
import '../../features/authentication/Logic/login_cubit.dart';
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

  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    passwordController = context.read<LoginCubit>().passwordController;
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        // hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        // hasSpecialCharacters =
        // AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        // hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

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
                if (value == null ||
                    value.isEmpty ||
                    !AppRegex.isEmailValid(value)) {
                  return 'please enter a valid email';
                }
              },
              controller: context.read<LoginCubit>().emailController,
            ),
            SizedBox(
              height: 12.h,
            ),
            CustomTextField(
              hintText: 'Password',
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 18,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !AppRegex.isPasswordValid(value)) {
                  return 'please enter a valid password';
                }
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
