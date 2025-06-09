import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/order_notification_model.dart';

class NotificationService {
  final String baseUrl = 'https://final.agrovision.ltd/api';
  
  Future<List<OrderNotification>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notification'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here if needed
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => OrderNotification.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notification/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here if needed
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }
} 