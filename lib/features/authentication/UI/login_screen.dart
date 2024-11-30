import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/emai_and_password.dart';
import '../Data/model/login_request_body.dart';
import '../Logic/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60.h,
                ),
                Image.asset(
                  'assets/images/authentication/logo4login.png',
                  height: 250.h,
                  width: 250.w,
                ),
                SizedBox(
                  height: 22.h,
                ),
                const EmailAndPassword(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomBottom(
                  text: 'Log In',
                  onPressed: () {
                    if (kDebugMode) {
                      print(context.read<LoginCubit>().emailController.text);
                    }
                    if (kDebugMode) {
                      print(context.read<LoginCubit>().passwordController.text);
                    }
                    if (kDebugMode) {
                      print('object');
                    }
                    validateThenDoLogin(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoLogin(BuildContext context) {
    if (context.read<LoginCubit>().formKey.currentState!.validate()) {
      context.read<LoginCubit>().emitLoginStates(
            LoginRequestBody(
              email: context.read<LoginCubit>().emailController.text,
              password: context.read<LoginCubit>().passwordController.text,
            ),
          );
    }
  }
}
