import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/utils.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/emai_and_password.dart';
import '../../../shared/widgets/show_custom_notification_error.dart';
import '../Data/model/login_request_body.dart';
import '../Logic/login_cubit.dart';
import '../Logic/login_state.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is Success) {
            Navigator.pushReplacementNamed(context, '/screenLayout');
          } else if (state is Error) {
            final errorMessage = state.error == 'Unauthorized'
                ? 'Invalid email or password. Please try again.'
                : state.error;

            showCustomNotification(context, errorMessage, AppColors.greyColor);
          }
        },
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
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.forgotPasswordPhone);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'SYNE',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return CustomBottom(
                      text: 'Log In',
                      onPressed: () {
                        Utils.closeKeyboard(context);

                        if (kDebugMode) {
                          print(
                              context.read<LoginCubit>().emailController.text);
                          print(context
                              .read<LoginCubit>()
                              .passwordController
                              .text);
                        }

                        validateThenDoLogin(context);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      )),
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
