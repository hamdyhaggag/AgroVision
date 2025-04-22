import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

ThemeData lightTheme = ThemeData(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
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
        // displayLarge: AppStyles.cairo32.copyWith(color: AppColors.blackColor),
        // headlineLarge: AppStyles.cairo24.copyWith(color: AppColors.blackColor),
        // bodyLarge: AppStyles.cairo20.copyWith(color: AppColors.blackColor),
        // bodyMedium: AppStyles.cairo16.copyWith(color: AppColors.blackColor),
        // bodySmall: AppStyles.cairo14.copyWith(color: AppColors.blackColor),
        ));
