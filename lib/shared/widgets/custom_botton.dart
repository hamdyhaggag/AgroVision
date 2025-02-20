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
  });

  final String text;
  final VoidCallback onPressed;
  final Function(String?)? validator;
  final Color? color;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 347.w,
      height: 48.h,
      child: MaterialButton(
        color: color ?? AppColors.primaryColor,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        elevation: 0,
        hoverElevation: 1,
        focusElevation: 1,
        highlightElevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            color: color?.withValues(alpha: 0.2) ??
                AppColors.primaryColor.withValues(alpha: 0.2),
            width: 1.r,
          ),
        ),
        onPressed: onPressed,
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
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
