import 'package:agro_vision/features/authentication/UI/congratulation_screen.dart';
import 'package:agro_vision/features/home/Ui/widgets/add_task_screen.dart';
import 'package:agro_vision/features/home/Ui/logout_screen.dart';
import 'package:agro_vision/features/home/Ui/widgets/task_list_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/Logic/auth cubit/auth_cubit.dart';
import '../../features/authentication/UI/create_password_screen.dart';
import '../../features/authentication/UI/forgot password/forgot_password_email.dart';
import '../../features/authentication/UI/forgot password/forgot_password_phone.dart';
import '../../features/authentication/UI/login_screen.dart';
import '../../features/authentication/UI/otp/otp_email_screen.dart';
import '../../features/authentication/UI/otp/otp_phone_screen.dart';
import '../../features/chat/Ui/chat_bot_detail_screen.dart';
import '../../features/chat/Ui/chat_screen.dart';
import '../../features/chat/models/farmer_chat_model.dart';
import '../../features/disease_detection/Ui/detection_records.dart';
import '../../features/home/Ui/crop_health.dart';
import '../../features/home/Ui/drawer/farm_inventory.dart';
import '../../features/home/Ui/drawer/order_analytics.dart';
import '../../features/home/Ui/drawer/order_management.dart';
import '../../features/home/Ui/drawer/settings_screen.dart';

import '../../features/home/Ui/notifications_screen.dart';
import '../../features/home/Ui/screen_layout.dart';
import '../../features/monitoring/UI/sensor_data_screen.dart';
import '../../features/onboarding/Ui/onboarding_screen.dart';
import '../../features/splash/Ui/splash_screen.dart';
import '../../features/chat/ui/chat_list_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static BuildContext? currentContext = navigatorKey.currentContext;

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case AppRoutes.screenLayout:
        return MaterialPageRoute(
          builder: (_) => const ScreenLayout(),
        );
      case AppRoutes.forgotPasswordPhone:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPhone(),
        );
      case AppRoutes.otpPhoneScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpPhoneScreen(),
        );
      case AppRoutes.forgotPasswordEmail:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordEmail(),
        );
      case AppRoutes.otpEmailScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpEmailScreen(email: 'user@example.com'),
        );
      case AppRoutes.createNewPassword:
        return MaterialPageRoute(
          builder: (_) => const CreateNewPassword(),
        );
      case AppRoutes.congratulationsScreen:
        return MaterialPageRoute(
          builder: (_) => const CongratulationsScreen(),
        );
      case AppRoutes.logout:
        return MaterialPageRoute(
          builder: (_) => const LogoutScreen(),
        );
      case AppRoutes.notificationsScreen:
        return MaterialPageRoute(
          builder: (_) => NotificationsScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case AppRoutes.sensorDataScreen:
        return MaterialPageRoute(
          builder: (_) => const SensorDataScreen(
            field: {},
          ),
        );

      case AppRoutes.chatList:
        return MaterialPageRoute(
          builder: (_) => const ChatListScreen(),
        );
      case AppRoutes.detectionRecords:
        return MaterialPageRoute(
          builder: (_) => const DetectionRecords(),
        );
      case AppRoutes.chatBotDetail:
        return MaterialPageRoute(
          builder: (_) => const ChatBotDetailScreen(),
        );

      case AppRoutes.farmerChatScreen:
        final args = settings.arguments is Map<String, dynamic>
            ? settings.arguments as Map<String, dynamic>
            : <String, dynamic>{};

        Conversation? conversation;

        try {
          conversation = args['conversation'] as Conversation;
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing chat arguments: $e');
          }
        }

        return MaterialPageRoute(
          builder: (_) => FarmerChatScreen(
            conversation: conversation ??
                Conversation(
                  id: -1,
                  user1Id: 0,
                  user2Id: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  messages: [],
                ),
          ),
        );
      case '/orderAnalytics':
        return MaterialPageRoute(
          builder: (_) => const OrderAnalytics(),
        );

      case '/orderManagement':
        return MaterialPageRoute(
          builder: (_) => const OrderManagementScreen(),
        );
      case '/farmInventory':
        return MaterialPageRoute(
          builder: (_) => const FarmInventoryScreen(),
        );
      case '/sensorData':
        return MaterialPageRoute(
          builder: (_) => const SensorDataScreen(
            field: {},
          ),
        );
      case '/settingsScreen':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case AppRoutes.cropHealth:
        return MaterialPageRoute(builder: (_) => const CropHealth());
      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case AppRoutes.allTasks:
        return MaterialPageRoute(builder: (_) => const TaskListScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const ScreenLayout(),
        );
    }
  }
}
