import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../notifications/services/notification_service.dart';
import '../../notifications/cubit/notification_cubit.dart';
import '../../notifications/screens/notification_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notifications',
        isHome: false,
      ),
      body: BlocProvider(
        create: (context) =>
            NotificationCubit(NotificationService())..loadNotifications(),
        child: const NotificationScreen(),
      ),
    );
  }
}
