import 'package:flutter/material.dart';

import '../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/notification.png'),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'SYNE',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      notification.timeAgo,
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
          if (notification.isUnread)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.circle,
                color: Colors.green,
                size: 12,
              ),
            ),
        ],
      ),
    );
  }
}
