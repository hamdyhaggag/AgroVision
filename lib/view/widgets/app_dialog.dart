import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_colors.dart';
import 'app_text.dart';

class AppDialog extends StatefulWidget {
  const AppDialog({
    super.key,
    required this.content,
    required this.okAction,
    required this.cancelAction,
  });

  final String content;
  final AppDialogAction okAction;
  final AppDialogAction cancelAction;

  static Future<void> showAppDialog({
    required BuildContext context,
    required String content,
    required AppDialogAction okAction,
    required AppDialogAction cancelAction,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.5,
          sigmaY: 2.5,
        ),
        child: AppDialog(
          content: content,
          okAction: okAction,
          cancelAction: cancelAction,
        ),
      ),
    );
  }

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 220,
      ),
    );
    scaleAnimation = controller.view;
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
        scale: scaleAnimation,
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            await controller.reverse();
            return Future.value(true);
          },
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                    child: AppText(
                      widget.content,
                      fontSize: 21,
                      fontFamily: 'DIN',
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : AppColors.primaryColor,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.blackColor,
                            backgroundColor:
                                isDarkMode ? Colors.black12 : Colors.white,
                            side: BorderSide(
                              color: isDarkMode
                                  ? Colors.transparent
                                  : AppColors.primaryColor, // Border color
                            ),
                          ),
                          onPressed: widget.cancelAction.onTap,
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            child: AppText(
                              widget.cancelAction.title,
                              fontSize: 19,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.blackColor,
                            backgroundColor:
                                isDarkMode ? Colors.black12 : Colors.white,
                            side: BorderSide(
                              color: isDarkMode
                                  ? Colors.transparent
                                  : AppColors.primaryColor,
                            ),
                          ),
                          onPressed: widget.okAction.onTap,
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.center,
                            child: AppText(
                              widget.okAction.title,
                              fontFamily: 'DIN',
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class AppDialogAction {
  final String title;
  final VoidCallback onTap;

  AppDialogAction({
    required this.title,
    required this.onTap,
  });
}
