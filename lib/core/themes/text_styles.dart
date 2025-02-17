import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/core/themes/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  TextStyles._();

  static final TextStyle size12PrimaryRegular = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'SYNE',
    color: AppColors.primaryColor,
    fontWeight: FontWeights.regular,
  );

  static final TextStyle size14GreyDarkLight = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'SYNE',
    color: AppColors.greyColor,
    fontWeight: FontWeights.light,
  );

  static final TextStyle size16BlackRegular = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'SYNE',
    color: AppColors.blackColor,
    fontWeight: FontWeights.regular,
  );
  static TextStyle heading1 = TextStyle(
      fontSize: 24.sp, fontFamily: 'SYNE', fontWeight: FontWeight.bold);
  static TextStyle heading2 = TextStyle(
      fontSize: 20.sp, fontFamily: 'SYNE', fontWeight: FontWeight.bold);
  static TextStyle bodyText =
      TextStyle(fontSize: 16.sp, fontFamily: 'SYNE', color: Colors.black);
  static TextStyle buttonText = TextStyle(
      fontSize: 16.sp,
      fontFamily: 'SYNE',
      fontWeight: FontWeight.bold,
      color: Colors.white);
}
