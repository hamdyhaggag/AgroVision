import 'package:bloc/bloc.dart';
import 'package:agro_vision/models/notification_model.dart';
import '../../../../core/helpers/cache_helper.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(notifications: [])) {
    _loadCachedNotifications();
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
              timeAgo: n.timeAgo,
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
          timeAgo: n.timeAgo,
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
}
