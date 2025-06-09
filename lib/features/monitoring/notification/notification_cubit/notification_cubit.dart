import 'dart:developer' as dev;
import 'package:bloc/bloc.dart';
import 'package:agro_vision/models/notification_model.dart';
import 'package:agro_vision/shared/services/notification_service.dart';
import 'notification_state.dart';
import '../../../../features/authentication/Logic/auth cubit/auth_cubit.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService = NotificationService();

  NotificationCubit() : super(NotificationState(notifications: [])) {
    dev.log('Initializing NotificationCubit', name: 'NotificationCubit');
    _loadNotifications();
  }

  void handleAuthStateChange(AuthState state) {
    dev.log(
      'Handling auth state change: ${state.runtimeType}',
      name: 'NotificationCubit',
    );
    if (state is UserUpdatedState) {
      _loadNotifications();
    } else if (state is UserClearedState) {
      clearNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    dev.log('Loading notifications', name: 'NotificationCubit');
    try {
      emit(state.copyWith(isLoading: true));
      final notifications = _notificationService.getNotifications();
      emit(state.copyWith(
        notifications: notifications,
        isLoading: false,
        selectedFilter: null,
      ));
      dev.log(
        'Loaded ${notifications.length} notifications',
        name: 'NotificationCubit',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to load notifications',
        name: 'NotificationCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(
        error: 'Failed to load notifications: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    dev.log(
      'Adding notification: ${notification.id}',
      name: 'NotificationCubit',
    );
    try {
      await _notificationService.saveNotification(notification);
      await _notificationService.showLocalNotification(
        title: notification.title,
        body: notification.description,
        payload: notification.id,
      );
      await _loadNotifications();
      dev.log(
        'Notification added successfully',
        name: 'NotificationCubit',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to add notification',
        name: 'NotificationCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: 'Failed to add notification: $e'));
    }
  }

  Future<void> markAllAsRead() async {
    dev.log('Marking all notifications as read', name: 'NotificationCubit');
    try {
      await _notificationService.markAllAsRead();
      await _loadNotifications();
      dev.log(
        'All notifications marked as read successfully',
        name: 'NotificationCubit',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to mark all notifications as read',
        name: 'NotificationCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: 'Failed to mark all as read: $e'));
    }
  }

  Future<void> markAsRead(NotificationModel notification) async {
    dev.log(
      'Marking notification as read: ${notification.id}',
      name: 'NotificationCubit',
    );
    try {
      await _notificationService.markAsRead(notification.id);
      await _loadNotifications();
      dev.log(
        'Notification marked as read successfully',
        name: 'NotificationCubit',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to mark notification as read',
        name: 'NotificationCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: 'Failed to mark as read: $e'));
    }
  }

  Future<void> clearNotifications() async {
    dev.log('Clearing all notifications', name: 'NotificationCubit');
    try {
      await _notificationService.clearNotifications();
      emit(state.copyWith(notifications: []));
      dev.log(
        'Notifications cleared successfully',
        name: 'NotificationCubit',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to clear notifications',
        name: 'NotificationCubit',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: 'Failed to clear notifications: $e'));
    }
  }

  void setFilter(String? filter) {
    dev.log(
      'Setting filter: ${filter ?? 'All'}',
      name: 'NotificationCubit',
    );

    // If the current filter is the same as the new filter, deselect it (return to "All")
    if (state.selectedFilter == filter) {
      final newState = state.copyWith(selectedFilter: null);
      emit(newState);
      dev.log('Filter deselected, returning to All', name: 'NotificationCubit');
    } else {
      // Create a new state with the updated filter
      final newState = state.copyWith(selectedFilter: filter);
      emit(newState);
      dev.log(
        'Filter set to: ${filter ?? 'All'}',
        name: 'NotificationCubit',
      );
    }
  }

  int getUnreadCount() {
    final count = _notificationService.getUnreadCount();
    dev.log(
      'Unread notification count: $count',
      name: 'NotificationCubit',
    );
    return count;
  }
}
