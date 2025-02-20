import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomNotification(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  NotificationType type = NotificationType.info,
  String? title,
  int durationSeconds = 3,
}) {
  if (!context.mounted || message.isEmpty) return;

  late OverlayEntry overlayEntry;
  final theme = Theme.of(context);
  final iconData = _getIconForType(type);
  final accentColor = _getColorForType(type, theme);

  overlayEntry = OverlayEntry(
    builder: (context) {
      final route = ModalRoute.of(context);
      final routeAnimation = route?.animation;
      final mediaQuery = MediaQuery.of(context);

      Widget content = SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16.r,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildProgressIndicator(durationSeconds, accentColor),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Icon(iconData, color: accentColor, size: 24.r),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title != null)
                                Text(
                                  title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              Text(
                                message,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 20.r),
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          onPressed: () => overlayEntry.remove(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      return routeAnimation != null
          ? PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTRB(0, 0, 0, -100),
                  mediaQuery.size,
                ),
                end: RelativeRect.fromSize(
                  Rect.fromLTRB(0, 0, 0, 30.h),
                  mediaQuery.size,
                ),
              ).animate(CurvedAnimation(
                parent: routeAnimation,
                curve: Curves.fastOutSlowIn,
              )),
              child: content,
            )
          : Positioned(
              top: 30.h,
              left: 16.w,
              right: 16.w,
              child: content,
            );
    },
  );

  final overlay = Overlay.of(context);
  overlay.insert(overlayEntry);
  Future.delayed(Duration(seconds: durationSeconds), () {
    if (overlayEntry.mounted) overlayEntry.remove();
  });
}

Widget _buildProgressIndicator(int duration, Color color) {
  return SizedBox(
    height: 3.h,
    child: TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: Duration(seconds: duration),
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.transparent,
          color: color,
          minHeight: 3.h,
        );
      },
    ),
  );
}

enum NotificationType { success, error, warning, info }

IconData _getIconForType(NotificationType type) {
  switch (type) {
    case NotificationType.success:
      return Icons.check_circle;
    case NotificationType.error:
      return Icons.error;
    case NotificationType.warning:
      return Icons.warning;
    default:
      return Icons.info;
  }
}

Color _getColorForType(NotificationType type, ThemeData theme) {
  switch (type) {
    case NotificationType.success:
      return theme.colorScheme.primary;
    case NotificationType.error:
      return theme.colorScheme.error;
    case NotificationType.warning:
      return const Color(0xFFFFA000);
    default:
      return theme.colorScheme.secondary;
  }
}
