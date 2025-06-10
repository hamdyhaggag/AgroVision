import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/unified_notification_model.dart';
import '../services/unified_notification_service.dart';

// Events
abstract class UnifiedNotificationEvent extends Equatable {
  const UnifiedNotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadUnifiedNotifications extends UnifiedNotificationEvent {}

class MarkNotificationAsRead extends UnifiedNotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends UnifiedNotificationEvent {}

// States
abstract class UnifiedNotificationState extends Equatable {
  const UnifiedNotificationState();

  @override
  List<Object> get props => [];
}

class UnifiedNotificationInitial extends UnifiedNotificationState {}

class UnifiedNotificationLoading extends UnifiedNotificationState {}

class UnifiedNotificationLoaded extends UnifiedNotificationState {
  final List<UnifiedNotification> notifications;
  final String? selectedFilter;

  const UnifiedNotificationLoaded({
    required this.notifications,
    this.selectedFilter,
  });

  List<UnifiedNotification> get filteredNotifications {
    if (selectedFilter == null || selectedFilter == 'All') {
      return notifications;
    }
    if (selectedFilter == 'Unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    if (selectedFilter == 'Orders') {
      return notifications
          .where((n) => n.type == NotificationType.order)
          .toList();
    }
    if (selectedFilter == 'General') {
      return notifications
          .where((n) => n.type == NotificationType.general)
          .toList();
    }
    return notifications;
  }

  @override
  List<Object> get props => [notifications, selectedFilter ?? ''];
}

class UnifiedNotificationError extends UnifiedNotificationState {
  final String message;

  const UnifiedNotificationError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class UnifiedNotificationCubit extends Cubit<UnifiedNotificationState> {
  final UnifiedNotificationService _notificationService;

  UnifiedNotificationCubit(this._notificationService)
      : super(UnifiedNotificationInitial());

  Future<void> loadNotifications() async {
    try {
      emit(UnifiedNotificationLoading());
      final notifications = await _notificationService.getNotifications();
      emit(UnifiedNotificationLoaded(notifications: notifications));
    } catch (e) {
      emit(UnifiedNotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      await loadNotifications();
    } catch (e) {
      emit(UnifiedNotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      await loadNotifications();
    } catch (e) {
      emit(UnifiedNotificationError(e.toString()));
    }
  }

  void setFilter(String? filter) {
    if (state is UnifiedNotificationLoaded) {
      final currentState = state as UnifiedNotificationLoaded;
      emit(UnifiedNotificationLoaded(
        notifications: currentState.notifications,
        selectedFilter: filter,
      ));
    }
  }
}
