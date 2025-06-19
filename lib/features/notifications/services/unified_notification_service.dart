import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/helpers/cache_helper.dart';
import '../../../models/unified_notification_model.dart';
import '../../../models/order_notification_model.dart';
import '../../../models/notification_model.dart';
import '../../../shared/services/notification_service.dart';

class UnifiedNotificationService {
  final String baseUrl = dotenv.env['AGROVISION_API_BASE_URL'] ??
      'https://final.agrovision.ltd/api';
  final NotificationService _localNotificationService = NotificationService();

  Future<List<UnifiedNotification>> getNotifications() async {
    try {
      final token = await CacheHelper.getString(key: 'token');
      if (token.isEmpty) {
        dev.log('Authentication token not found',
            name: 'UnifiedNotificationService');
        throw Exception('Authentication token not found');
      }

      dev.log('Fetching order notifications from API',
          name: 'UnifiedNotificationService');
      // Get order notifications
      final orderResponse = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      dev.log(
          'Order notifications API response status: ${orderResponse.statusCode}',
          name: 'UnifiedNotificationService');
      if (orderResponse.statusCode != 200) {
        dev.log('Error response from API: ${orderResponse.body}',
            name: 'UnifiedNotificationService');
        dev.log('Request headers: ${orderResponse.request?.headers}',
            name: 'UnifiedNotificationService');
      }

      // Get local notifications
      final localNotifications = _localNotificationService.getNotifications();
      dev.log('Retrieved ${localNotifications.length} local notifications',
          name: 'UnifiedNotificationService');

      List<UnifiedNotification> unifiedNotifications = [];

      // Process order notifications
      if (orderResponse.statusCode == 200) {
        final List<dynamic> orderJsonData = json.decode(orderResponse.body);
        dev.log(
            'Retrieved ${orderJsonData.length} order notifications from API',
            name: 'UnifiedNotificationService');

        final orderNotifications = orderJsonData
            .map((json) => OrderNotification.fromJson(json))
            .toList();

        unifiedNotifications.addAll(
          orderNotifications.map(UnifiedNotification.fromOrderNotification),
        );
        dev.log(
            'Converted ${orderNotifications.length} order notifications to unified format',
            name: 'UnifiedNotificationService');
      }

      // Process local notifications
      unifiedNotifications.addAll(
        localNotifications.map(UnifiedNotification.fromGeneralNotification),
      );
      dev.log('Total unified notifications: ${unifiedNotifications.length}',
          name: 'UnifiedNotificationService');

      // Sort notifications by date (newest first)
      unifiedNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return unifiedNotifications;
    } catch (e, stackTrace) {
      dev.log(
        'Error fetching notifications',
        name: 'UnifiedNotificationService',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await CacheHelper.getString(key: 'token');
      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Try to mark as read in both services
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/notifications/$notificationId/read'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'X-Requested-With': 'XMLHttpRequest',
          },
        );

        if (response.statusCode != 200) {
          dev.log('Error marking notification as read: ${response.body}',
              name: 'UnifiedNotificationService');
        }
      } catch (e) {
        dev.log('Error marking order notification as read',
            name: 'UnifiedNotificationService', error: e);
        // Ignore errors from order notifications
      }

      try {
        await _localNotificationService.markAsRead(notificationId);
      } catch (e) {
        dev.log('Error marking local notification as read',
            name: 'UnifiedNotificationService', error: e);
        // Ignore errors from local notifications
      }
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = await CacheHelper.getString(key: 'token');
      if (token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Mark all as read in both services
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/notifications/mark-all-read'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'X-Requested-With': 'XMLHttpRequest',
          },
        );

        if (response.statusCode != 200) {
          dev.log('Error marking all notifications as read: ${response.body}',
              name: 'UnifiedNotificationService');
        }
      } catch (e) {
        dev.log('Error marking all order notifications as read',
            name: 'UnifiedNotificationService', error: e);
        // Ignore errors from order notifications
      }

      try {
        await _localNotificationService.markAllAsRead();
      } catch (e) {
        dev.log('Error marking all local notifications as read',
            name: 'UnifiedNotificationService', error: e);
        // Ignore errors from local notifications
      }
    } catch (e) {
      throw Exception('Error marking all notifications as read: $e');
    }
  }
}
