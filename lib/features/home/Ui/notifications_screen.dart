import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: "DISEASES",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      timeAgo: "1m ago",
      category: "Diseases",
      isUnread: true,
    ),
    NotificationModel(
      title: "Weeds",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      timeAgo: "10 Hrs ago",
      category: "Weeds",
    ),
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notifications',
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(notification: notifications[index]);
        },
      ),
    );
  }
}
