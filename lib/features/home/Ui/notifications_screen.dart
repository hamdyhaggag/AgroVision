import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/notification_model.dart';
import '../../monitoring/notification/notification_cubit/notification_cubit.dart';
import '../../monitoring/notification/notification_cubit/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              context.read<NotificationCubit>().markAllAsRead();
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final notifications = state.notifications;
          if (notifications.isEmpty) {
            return const Center(
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
            );
          }

          List<dynamic> notificationItems = [];
          String? previousCategory;
          for (var notification in notifications) {
            if (notification.category != previousCategory) {
              notificationItems.add(notification.category);
              previousCategory = notification.category;
            }
            notificationItems.add(notification);
          }

          return RefreshIndicator(
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
                      onTap: () =>
                          context.read<NotificationCubit>().markAsRead(item));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'temperature':
      case 'temp':
        return Icons.thermostat;
      case 'humidity':
      case 'hum':
        return Icons.water_drop;
      case 'soil':
        return Icons.grass;
      case 'ec':
        return Icons.electrical_services;
      case 'ph':
        return Icons.science;
      case 'n':
      case 'p':
      case 'k':
      case 'nutrient':
        return Icons.local_florist;
      case 'fertility':
        return Icons.agriculture;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'temperature':
      case 'temp':
        return Colors.red;
      case 'humidity':
      case 'hum':
        return Colors.blue;
      case 'soil':
        return Colors.brown;
      case 'ec':
        return Colors.purple;
      case 'ph':
        return Colors.teal;
      case 'n':
      case 'p':
      case 'k':
      case 'nutrient':
        return Colors.green;
      case 'fertility':
        return Colors.amber;
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
              ? Colors.green.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
                color: _getColorForType(notification.type).withOpacity(0.1),
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
