import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/notification_model.dart';
import '../../monitoring/notification/notification_cubit/notification_cubit.dart';
import '../../monitoring/notification/notification_cubit/notification_state.dart';
import '../../monitoring/notification/widget/notification_card.dart';
import '../../authentication/Logic/auth cubit/auth_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications based on current auth state
    final authState = context.read<AuthCubit>().state;
    context.read<NotificationCubit>().handleAuthStateChange(authState);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        context.read<NotificationCubit>().handleAuthStateChange(state);
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isLoggedIn = context.watch<AuthCubit>().state is UserUpdatedState;

    if (!isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Notifications'),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please log in to view notifications',
                style: TextStyle(fontSize: 18, fontFamily: 'SYNE'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              context.read<NotificationCubit>().markAllAsRead();
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final notifications = state.notifications;
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet.',
                    style: TextStyle(fontSize: 18, fontFamily: 'SYNE'),
                  ),
                ],
              ),
            );
          }

          List<dynamic> notificationItems = [];
          String? previousCategory;
          for (var notification in notifications) {
            if (notification.category != previousCategory) {
              notificationItems.add(notification.category);
              previousCategory = notification.category;
            }
            notificationItems.add(notification);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              itemCount: notificationItems.length,
              itemBuilder: (context, index) {
                final item = notificationItems[index];
                if (item is String) {
                  return _buildSectionHeader(item);
                } else if (item is NotificationModel) {
                  return NotificationCard(
                      notification: item,
                      onTap: () =>
                          context.read<NotificationCubit>().markAsRead(item));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
