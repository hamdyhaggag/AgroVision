import 'dart:developer' as dev;
import 'package:agro_vision/models/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;
  final String? selectedFilter;
  final bool isRefreshing;

  NotificationState({
    required this.notifications,
    this.isLoading = false,
    this.error,
    this.selectedFilter,
    this.isRefreshing = false,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
    String? selectedFilter,
    bool? isRefreshing,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedFilter: selectedFilter,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  List<NotificationModel> get filteredNotifications {
    dev.log(
      'Filtering notifications with filter: ${selectedFilter ?? 'All'}',
      name: 'NotificationState',
    );

    // If no filter is selected or "All" is selected, return all notifications
    if (selectedFilter == null || selectedFilter == 'All') {
      dev.log('Returning all notifications', name: 'NotificationState');
      return notifications;
    }

    // Handle unread filter
    if (selectedFilter == 'unread') {
      final unread =
          notifications.where((notification) => notification.isUnread).toList();
      dev.log(
        'Filtered to ${unread.length} unread notifications',
        name: 'NotificationState',
      );
      return unread;
    }

    // Handle type filters
    final filtered = notifications.where((notification) {
      final matches = notification.type == selectedFilter;
      dev.log(
        'Notification ${notification.id} type ${notification.type} matches filter $selectedFilter: $matches',
        name: 'NotificationState',
      );
      return matches;
    }).toList();

    dev.log(
      'Filtered to ${filtered.length} notifications',
      name: 'NotificationState',
    );
    return filtered;
  }

  bool get hasUnreadNotifications =>
      notifications.any((notification) => notification.isUnread);

  int get unreadCount =>
      notifications.where((notification) => notification.isUnread).length;

  bool get hasError => error != null;

  bool get isEmpty => notifications.isEmpty;

  Map<String, int> get notificationCountsByType {
    final counts = <String, int>{};
    for (var notification in notifications) {
      counts[notification.type] = (counts[notification.type] ?? 0) + 1;
    }
    return counts;
  }
}
