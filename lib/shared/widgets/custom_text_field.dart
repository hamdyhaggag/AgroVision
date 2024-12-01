import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.onSaved,
    this.onChange,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.prefixIcon,
    required this.validator,
    this.controller,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.errorBorder,
    this.focusErrorBorder,
    this.keyboardType,
    this.errorMessage,
  });

  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusErrorBorder;
  final TextStyle? inputTextStyle;
  final String hintText;
  final void Function(String?)? onSaved;
  final void Function(String)? onChange;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final Function(String?) validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 347.w,
          height: 48.h,
          child: TextFormField(
            controller: controller,
            onChanged: onChange,
            onSaved: onSaved,
            cursorColor: AppColors.primaryColor,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: contentPadding ??
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              constraints: BoxConstraints(
                maxHeight: height * 0.0625,
                maxWidth: width,
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xff929BAB),
                fontSize: 14.sp,
                fontFamily: 'SYNE',
                fontWeight: FontWeight.normal,
              ),
              enabledBorder: enabledBorder ?? borderCustom(),
              focusedBorder:
                  focusedBorder ?? borderCustom(AppColors.primaryColor),
              errorBorder: errorBorder ?? borderCustom(Colors.red),
              focusedErrorBorder: focusErrorBorder ?? borderCustom(Colors.red),
            ),
            validator: (value) {
              return validator(value);
            },
            obscureText: isObscureText ?? false,
          ),
        ),
        if (errorMessage != null && errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 12.w),
            child: Text(
              errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'SYNE',
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder borderCustom([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? AppColors.primaryColorshade,
        width: 1.5,
      ),
    );
  }
}
