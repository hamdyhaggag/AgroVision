import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      title: 'Temperature Alert',
      description: 'High temperature detected in greenhouse A.',
      timeAgo: '2 mins ago',
      isUnread: true,
      type: 'temperature',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    NotificationModel(
      title: 'Humidity Warning',
      description: 'Low air humidity levels in field B.',
      timeAgo: '15 mins ago',
      isUnread: false,
      type: 'humidity',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    NotificationModel(
      title: 'Soil Moisture Alert',
      description: 'Soil moisture below threshold in sector C.',
      timeAgo: '1 day ago',
      isUnread: false,
      type: 'soil',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      title: 'Nutrient Alert - N',
      description: 'Low nitrogen levels detected in field F.',
      timeAgo: '2 days ago',
      isUnread: false,
      type: 'nutrient',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      title: 'Nutrient Alert - P',
      description: 'Low phosphorus levels in sector G.',
      timeAgo: '3 days ago',
      isUnread: false,
      type: 'nutrient',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isUnread = false;
      }
    });
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> notificationItems = [];
    String? previousCategory;

    for (var notification in _notifications) {
      if (notification.category != previousCategory) {
        notificationItems.add(notification.category);
        previousCategory = notification.category;
      }
      notificationItems.add(notification);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: notificationItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet.',
                    style: TextStyle(fontSize: 18, fontFamily: 'SYNE'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: notificationItems.length,
                itemBuilder: (context, index) {
                  final item = notificationItems[index];
                  if (item is String) {
                    return _buildSectionHeader(item);
                  } else if (item is NotificationModel) {
                    return NotificationCard(
                      notification: item,
                      onTap: () {
                        setState(() {
                          item.isUnread = false;
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard(
      {super.key, required this.notification, required this.onTap});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'soil':
        return Icons.grass;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'temperature':
        return Colors.red;
      case 'humidity':
        return Colors.blue;
      case 'soil':
        return Colors.brown;
      default:
        return Colors.grey;
    }
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
                    _getColorForType(notification.type).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(notification.type),
                color: _getColorForType(notification.type),
                size: 24,
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
          ],
        ),
      ),
    );
  }
}
