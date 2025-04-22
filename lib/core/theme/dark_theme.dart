import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

ThemeData darkTheme = ThemeData(
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.blackColor,
  ),
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    surfaceTintColor: Color(0xFF121212),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF121212),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.greyColor.withAlpha(128)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.greyColor.withAlpha(128)),
    ),
    // floatingLabelStyle: AppStyles.cairo14,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      backgroundColor: AppColors.primaryColor,
    ),
  ),
  textTheme: const TextTheme(
      // displayLarge: AppStyles.cairo32.copyWith(color: AppColors.whiteColor),
      // headlineLarge: AppStyles.cairo24.copyWith(color: AppColors.whiteColor),
      // bodyLarge: AppStyles.cairo20.copyWith(color: AppColors.whiteColor),
      // bodyMedium: AppStyles.cairo16.copyWith(color: AppColors.whiteColor),
      // bodySmall: AppStyles.cairo14.copyWith(color: AppColors.whiteColor),
      ),
);
