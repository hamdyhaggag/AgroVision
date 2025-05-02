import 'package:bloc/bloc.dart';
import 'package:agro_vision/models/notification_model.dart';
import '../../../../core/helpers/cache_helper.dart';
import 'notification_state.dart';
import '../../../../features/authentication/Logic/auth cubit/auth_cubit.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(notifications: [])) {
    // Don't load notifications on initialization
  }

  void handleAuthStateChange(AuthState state) {
    if (state is UserUpdatedState) {
      _loadCachedNotifications();
    } else if (state is UserClearedState) {
      clearNotifications();
    }
  }

  Future<void> _loadCachedNotifications() async {
    final cachedNotifications = CacheHelper.getNotifications();
    emit(state.copyWith(notifications: cachedNotifications));
  }

  void addNotification(NotificationModel notification) {
    final exists = state.notifications.any((n) => n.id == notification.id);
    if (!exists) {
      final updatedNotifications = [notification, ...state.notifications];
      emit(state.copyWith(notifications: updatedNotifications));
      CacheHelper.saveNotifications(updatedNotifications);
    }
  }

  void markAllAsRead() {
    final updatedNotifications = state.notifications
        .map((n) => NotificationModel(
              id: n.id,
              title: n.title,
              description: n.description,
              isUnread: false,
              type: n.type,
              timestamp: n.timestamp,
            ))
        .toList();
    emit(state.copyWith(notifications: updatedNotifications));
    CacheHelper.saveNotifications(updatedNotifications);
  }

  void markAsRead(NotificationModel notification) {
    final updatedNotifications = state.notifications.map((n) {
      if (n.id == notification.id) {
        return NotificationModel(
          id: n.id,
          title: n.title,
          description: n.description,
          isUnread: false,
          type: n.type,
          timestamp: n.timestamp,
        );
      }
      return n;
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
    CacheHelper.saveNotifications(updatedNotifications);
  }

  void clearNotifications() {
    emit(state.copyWith(notifications: []));
    CacheHelper.clearNotifications();
  }
}
