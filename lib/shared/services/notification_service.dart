import 'dart:developer' as dev;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:agro_vision/models/notification_model.dart';
import 'package:agro_vision/core/helpers/cache_helper.dart';
import 'package:agro_vision/features/authentication/Logic/auth cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isUserLoggedIn() {
    try {
      return CacheHelper.getBoolean(key: 'isLoggedIn') == true;
    } catch (e) {
      dev.log('Error checking auth state',
          name: 'NotificationService', error: e);
      return false;
    }
  }

  Future<void> initialize() async {
    dev.log('Initializing NotificationService', name: 'NotificationService');
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      dev.log('NotificationService initialized successfully',
          name: 'NotificationService');
    } catch (e, stackTrace) {
      dev.log(
        'Failed to initialize NotificationService',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    dev.log(
      'Notification tapped: ${response.payload}',
      name: 'NotificationService',
    );
    // TODO: Implement deep linking based on notification payload
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    NotificationImportance importance = NotificationImportance.high,
  }) async {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, skipping notification: $title',
        name: 'NotificationService',
      );
      return;
    }

    dev.log(
      'Showing local notification: $title',
      name: 'NotificationService',
    );
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'sensor_alerts',
        'Sensor Alerts',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
      dev.log(
        'Local notification shown successfully',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to show local notification',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> saveNotification(NotificationModel notification) async {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, skipping notification save: ${notification.id}',
        name: 'NotificationService',
      );
      return;
    }

    dev.log(
      'Saving notification: ${notification.id}',
      name: 'NotificationService',
    );
    try {
      final notifications = CacheHelper.getNotifications();
      final exists = notifications.any((n) => n.id == notification.id);
      if (!exists) {
        notifications.insert(0, notification);
        await CacheHelper.saveNotifications(notifications);
        dev.log(
          'Notification saved successfully',
          name: 'NotificationService',
        );
      } else {
        dev.log(
          'Notification already exists, skipping save',
          name: 'NotificationService',
        );
      }
    } catch (e, stackTrace) {
      dev.log(
        'Failed to save notification',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  List<NotificationModel> getNotifications() {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, returning empty notifications list',
        name: 'NotificationService',
      );
      return [];
    }

    dev.log(
      'Getting all notifications',
      name: 'NotificationService',
    );
    try {
      final notifications = CacheHelper.getNotifications();
      dev.log(
        'Retrieved ${notifications.length} notifications',
        name: 'NotificationService',
      );
      return notifications;
    } catch (e, stackTrace) {
      dev.log(
        'Failed to get notifications',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, skipping mark as read: $notificationId',
        name: 'NotificationService',
      );
      return;
    }

    dev.log(
      'Marking notification as read: $notificationId',
      name: 'NotificationService',
    );
    try {
      final notifications = CacheHelper.getNotifications();
      final updatedNotifications = notifications.map((n) {
        if (n.id == notificationId) {
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
      await CacheHelper.saveNotifications(updatedNotifications);
      dev.log(
        'Notification marked as read successfully',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to mark notification as read',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, skipping mark all as read',
        name: 'NotificationService',
      );
      return;
    }

    dev.log(
      'Marking all notifications as read',
      name: 'NotificationService',
    );
    try {
      final notifications = CacheHelper.getNotifications();
      final updatedNotifications = notifications.map((n) {
        return NotificationModel(
          id: n.id,
          title: n.title,
          description: n.description,
          isUnread: false,
          type: n.type,
          timestamp: n.timestamp,
        );
      }).toList();
      await CacheHelper.saveNotifications(updatedNotifications);
      dev.log(
        'All notifications marked as read successfully',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to mark all notifications as read',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> clearNotifications() async {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, skipping clear notifications',
        name: 'NotificationService',
      );
      return;
    }

    dev.log(
      'Clearing all notifications',
      name: 'NotificationService',
    );
    try {
      await CacheHelper.clearNotifications();
      dev.log(
        'Notifications cleared successfully',
        name: 'NotificationService',
      );
    } catch (e, stackTrace) {
      dev.log(
        'Failed to clear notifications',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  int getUnreadCount() {
    if (!_isUserLoggedIn()) {
      dev.log(
        'User not logged in, returning 0 unread count',
        name: 'NotificationService',
      );
      return 0;
    }

    dev.log(
      'Getting unread notification count',
      name: 'NotificationService',
    );
    try {
      final count =
          CacheHelper.getNotifications().where((n) => n.isUnread).length;
      dev.log(
        'Unread notification count: $count',
        name: 'NotificationService',
      );
      return count;
    } catch (e, stackTrace) {
      dev.log(
        'Failed to get unread notification count',
        name: 'NotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

enum NotificationImportance {
  low,
  medium,
  high,
}
