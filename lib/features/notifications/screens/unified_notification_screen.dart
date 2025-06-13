import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../cubit/unified_notification_cubit.dart';
import '../../../models/unified_notification_model.dart';

class UnifiedNotificationScreen extends StatelessWidget {
  const UnifiedNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CustomAppBar(
        title: 'Notifications',
        isHome: false,
      ),
      body: const _NotificationContent(),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnifiedNotificationCubit, UnifiedNotificationState>(
      builder: (context, state) {
        if (state is UnifiedNotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UnifiedNotificationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<UnifiedNotificationCubit>()
                        .loadNotifications();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is UnifiedNotificationLoaded) {
          if (state.notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.greyColor,
                ),
              ),
            );
          }

          return Column(
            children: [
              _buildFilterChips(context, state),
              Expanded(
                child: _buildNotificationList(context, state),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilterChips(
      BuildContext context, UnifiedNotificationLoaded state) {
    // Log available notification types for debugging
    final orderCount = state.notifications
        .where((n) => n.type == NotificationType.order)
        .length;
    final generalCount = state.notifications
        .where((n) => n.type == NotificationType.general)
        .length;
    dev.log(
        'Available notifications - Orders: $orderCount, General: $generalCount',
        name: 'UnifiedNotificationScreen');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              isSelected:
                  state.selectedFilter == null || state.selectedFilter == 'All',
              onSelected: (selected) {
                if (selected) {
                  context.read<UnifiedNotificationCubit>().setFilter('All');
                }
              },
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'Unread',
              isSelected: state.selectedFilter == 'Unread',
              onSelected: (selected) {
                if (selected) {
                  context.read<UnifiedNotificationCubit>().setFilter('Unread');
                }
              },
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'Orders',
              isSelected: state.selectedFilter == 'Orders',
              onSelected: (selected) {
                if (selected) {
                  context.read<UnifiedNotificationCubit>().setFilter('Orders');
                }
              },
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'General',
              isSelected: state.selectedFilter == 'General',
              onSelected: (selected) {
                if (selected) {
                  context.read<UnifiedNotificationCubit>().setFilter('General');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
      BuildContext context, UnifiedNotificationLoaded state) {
    final notifications = state.filteredNotifications;
    dev.log(
        'Building notification list with ${notifications.length} notifications',
        name: 'UnifiedNotificationScreen');
    dev.log('Filter type: ${state.selectedFilter}',
        name: 'UnifiedNotificationScreen');

    // Log notification types for debugging
    for (var notification in notifications) {
      dev.log(
          'Notification: ${notification.title} - Type: ${notification.type}',
          name: 'UnifiedNotificationScreen');
    }

    final groupedNotifications = _groupNotificationsByCategory(notifications);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final category = groupedNotifications.keys.elementAt(index);
        final categoryNotifications = groupedNotifications[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyColor,
                ),
              ),
            ),
            ...categoryNotifications.map((notification) => _NotificationCard(
                  notification: notification,
                  onTap: () {
                    context
                        .read<UnifiedNotificationCubit>()
                        .markAsRead(notification.id);
                  },
                )),
          ],
        );
      },
    );
  }

  Map<String, List<UnifiedNotification>> _groupNotificationsByCategory(
      List<UnifiedNotification> notifications) {
    final grouped = <String, List<UnifiedNotification>>{};
    for (final notification in notifications) {
      final category = notification.category;
      grouped.putIfAbsent(category, () => []).add(notification);
    }

    // Log grouped notifications for debugging
    dev.log('Grouped notifications:', name: 'UnifiedNotificationScreen');
    grouped.forEach((category, notifications) {
      dev.log('$category: ${notifications.length} notifications',
          name: 'UnifiedNotificationScreen');
    });

    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) {
          final order = {'Today': 0, 'Yesterday': 1, 'Older': 2};
          return order[a.key]!.compareTo(order[b.key]!);
        }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.primaryColor.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final UnifiedNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: notification.isRead
              ? Colors.grey[200]!
              : AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: AppColors.primaryColor,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notification.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData icon;
    Color iconColor;
    Color backgroundColor;

    switch (notification.type) {
      case NotificationType.order:
        icon = Icons.shopping_cart_outlined;
        iconColor = AppColors.primaryColor;
        backgroundColor = AppColors.primaryColor.withValues(alpha: 0.1);
        break;
      case NotificationType.general:
        icon = Icons.notifications_outlined;
        iconColor = AppColors.secondaryColor;
        backgroundColor = AppColors.secondaryColor.withValues(alpha: 0.1);
        break;
      case NotificationType.system:
        icon = Icons.settings_outlined;
        iconColor = AppColors.greyColor;
        backgroundColor = AppColors.greyLight;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[100] : backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: notification.isRead
            ? null
            : [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Icon(
        icon,
        color: notification.isRead ? Colors.grey[400] : iconColor,
        size: 22,
      ),
    );
  }
}
