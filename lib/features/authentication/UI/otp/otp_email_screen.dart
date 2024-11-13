import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_botton.dart';
import '../create_password_screen.dart';

class OtpEmailScreen extends StatefulWidget {
  const OtpEmailScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpEmailScreen> createState() => _OtpEmailScreenState();
}

class _OtpEmailScreenState extends State<OtpEmailScreen> {
  bool isLoading = false;
  int _start = 60;
  late Timer _timer;
  String? otpCode;
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verification code'),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/authentication/Otp_With_Email.svg',
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                '     Please enter the 6 digit code\n   sent to: ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.navy,
                            ),
                          ),
                          TextSpan(
                            text: widget.email,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: PinCodeTextField(
                      controller: otpController,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(6.r),
                        fieldHeight: 50.h,
                        fieldWidth: 50.w,
                        activeFillColor: Colors.white,
                        activeColor: AppColors.primaryColor,
                        inactiveColor: AppColors.primaryColorshade,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        disabledColor: Colors.white,
                        borderWidth: 0.1,
                        activeBorderWidth: 1.5,
                        inactiveBorderWidth: 1.5,
                        selectedBorderWidth: 1.5,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      onCompleted: (v) {
                        if (kDebugMode) {
                          print("Completed");
                        }
                      },
                      onChanged: (code) {
                        setState(() {
                          otpCode = code;
                        });
                        if (kDebugMode) {
                          print(code);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the OTP code';
                        } else if (value.length != 6) {
                          return 'OTP code must be 6 digits';
                        }
                        return null;
                      },
                      appContext: context,
                    )),
                CustomBottom(
                    text: 'Verify Code',
                    onPressed: () {
                      validateTheDoVerify(context);
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _start.toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _start = 45;
                    });
                    startTimer();
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateTheDoVerify(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (otpCode != null && otpCode!.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CreateNewPassword(
                      email: widget.email,
                    )));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Missing OTP Code'),
            content:
                const Text('Please enter the OTP code sent to your email.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
