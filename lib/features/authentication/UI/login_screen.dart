import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/custom_botton.dart';
import '../../../shared/widgets/emai_and_password.dart';
import '../Data/model/login_request_body.dart';
import '../Logic/login_cubit.dart';
import '../Logic/login_state.dart';

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

            showCustomNotification(context, errorMessage, Colors.red);
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
                      onTap: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'SYNE',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const CircularProgressIndicator();
                    }
                    return CustomBottom(
                      text: 'Log In',
                      onPressed: () {
                        if (kDebugMode) {
                          print(
                              context.read<LoginCubit>().emailController.text);
                        }
                        if (kDebugMode) {
                          print(context
                              .read<LoginCubit>()
                              .passwordController
                              .text);
                        }
                        validateThenDoLogin(context);
                      },
                    );
                  },
                ),
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

  void showCustomNotification(
      BuildContext context, String message, Color color) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            color: color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    overlayEntry.remove();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry into the Overlay
    Overlay.of(context).insert(overlayEntry);

    // Automatically remove the notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
