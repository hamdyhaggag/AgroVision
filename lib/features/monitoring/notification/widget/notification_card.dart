import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../models/notification_model.dart';
import '../notification_utils.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });
  final Map<String, String> _svgAssetForType = {
    'temperature': 'assets/images/sensor_icon/Temp.svg',
    'moisture': 'assets/images/sensor_icon/Humidity.svg',
    'ec': 'assets/images/sensor_icon/Ec.svg',
    'ph': 'assets/images/sensor_icon/Ph.svg',
    'n': 'assets/images/sensor_icon/N.svg',
    'p': 'assets/images/sensor_icon/P.svg',
    'k': 'assets/images/sensor_icon/K.svg',
    'fertility': 'assets/images/sensor_icon/Fertility.svg',
  };

  Widget getSvgIconForType(
    String type, {
    double size = 18.0,
    Color? color,
    String? semanticsLabel,
  }) {
    final asset = _svgAssetForType[type] ?? 'assets/icon/notifications.svg';
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      color: color,
      semanticsLabel: semanticsLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: notification.isUnread
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    getColorForType(notification.type).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: getSvgIconForType(
                notification.type,
                size: 18,
                color: getColorForType(notification.type),
                semanticsLabel: '${notification.type} icon',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SYNE',
                          fontWeight: notification.isUnread
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        formatTimeAgo(notification.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'SYNE',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SYNE',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
