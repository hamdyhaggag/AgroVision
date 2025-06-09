import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/notification_model.dart';
import '../../monitoring/notification/notification_cubit/notification_cubit.dart';
import '../../monitoring/notification/notification_cubit/notification_state.dart';
import '../../monitoring/notification/widget/notification_card.dart';
import '../../authentication/Logic/auth cubit/auth_cubit.dart';
import '../../../core/themes/app_colors.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    context.read<NotificationCubit>().handleAuthStateChange(authState);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    final theme = Theme.of(context);

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
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.notifications.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: () {
                  context.read<NotificationCubit>().markAllAsRead();
                },
                tooltip: 'Mark all as read',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: const TextStyle(fontSize: 18, fontFamily: 'SYNE'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().handleAuthStateChange(
                            context.read<AuthCubit>().state,
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.isEmpty) {
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

          return Column(
            children: [
              _buildFilterChips(context, state),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotificationCubit>().handleAuthStateChange(
                          context.read<AuthCubit>().state,
                        );
                  },
                  child: _buildNotificationList(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, NotificationState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All',
              isSelected: state.selectedFilter == null,
              onSelected: (selected) {
                if (selected) {
                  context.read<NotificationCubit>().setFilter(null);
                }
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Unread',
              isSelected: state.selectedFilter == 'unread',
              onSelected: (selected) {
                if (selected) {
                  context.read<NotificationCubit>().setFilter('unread');
                }
              },
            ),
            const SizedBox(width: 8),
            ...['moisture', 'n', 'p', 'k', 'fertility'].map((type) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildFilterChip(
                  label: type.capitalize(),
                  isSelected: state.selectedFilter == type,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<NotificationCubit>().setFilter(type);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).primaryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withOpacity(0.5),
        width: isSelected ? 2.0 : 1.0,
      ),
      elevation: isSelected ? 4.0 : 0.0,
      shadowColor: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.5)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, NotificationState state) {
    final filteredNotifications = state.filteredNotifications;

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.selectedFilter == null
                  ? 'No notifications yet'
                  : 'No ${state.selectedFilter} notifications',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return NotificationCard(
      notification: notification,
      onTap: () => context.read<NotificationCubit>().markAsRead(notification),
    );
  }
}
