import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/themes/app_colors.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({
    super.key,
    required this.text,
    required this.onPressed,
    this.validator,
    this.color,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.textStyle,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback onPressed;
  final Function(String?)? validator;
  final Color? color;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor =
        isLoading ? Colors.white : (color ?? AppColors.primaryColor);
    final Color borderColor = buttonColor.withValues(alpha: 0.2);

    return SizedBox(
      width: 347.w,
      height: 48.h,
      child: MaterialButton(
        color: buttonColor,
        textColor: isLoading ? AppColors.primaryColor : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            color: borderColor,
            width: 1.r,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(buttonColor),
      ),
    );
  }

  Widget _buildButtonContent(Color buttonColor) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: buttonColor == Colors.white
                ? AppColors.primaryColor
                : Colors.white,
          ),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize ?? 20.sp,
            color: iconColor ?? Colors.white,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: textStyle ??
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
    );
  }
}
