import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/order_notification_model.dart';
import '../services/notification_service.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final int notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<OrderNotification> notifications;

  const NotificationLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;

  NotificationCubit(this._notificationService) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    try {
      emit(NotificationLoading());
      final notifications = await _notificationService.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      // Reload notifications after marking as read
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
} 