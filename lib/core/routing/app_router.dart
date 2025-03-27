// import 'package:agro_vision/features/home/Ui/add_new_note.dart';
// import '../../features/home/Ui/edit_note_screen.dart';
// // import '../../features/home/Ui/notes_screen.dart';
import 'package:agro_vision/features/authentication/UI/congratulation_screen.dart';
import 'package:agro_vision/features/home/Ui/widgets/add_task_screen.dart';
import 'package:agro_vision/features/home/Ui/logout_screen.dart';
// import 'package:agro_vision/features/home/Ui/fields_screen.dart';
import 'package:agro_vision/features/home/Ui/profile/profile_screen.dart';
import 'package:agro_vision/features/home/Ui/widgets/task_list_screen.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/UI/create_password_screen.dart';
import '../../features/authentication/UI/forgot password/forgot_password_email.dart';
import '../../features/authentication/UI/forgot password/forgot_password_phone.dart';
import '../../features/authentication/UI/otp/otp_email_screen.dart';
import '../../features/authentication/UI/otp/otp_phone_screen.dart';
import '../../features/chat/Ui/consultation_chat_screen.dart';
import '../../features/disease_detection/Ui/detection_records.dart';
import '../../features/home/Ui/crop_health.dart';
import '../../features/home/Ui/drawer/crops_managment.dart';
import '../../features/home/Ui/drawer/farm_analytics.dart';
import '../../features/home/Ui/drawer/farm_inventory.dart';
import '../../features/home/Ui/drawer/settings_screen.dart';
import '../../features/home/Ui/drawer/team.dart';

import '../../features/home/Ui/notifications_screen.dart';
import '../../features/home/Ui/profile/edit_profile_screen.dart';
import '../../features/home/Ui/screen_layout.dart';
import '../../features/monitoring/UI/sensor_data_screen.dart';
import '../../features/onboarding/Ui/onboarding_screen.dart';
import '../../features/splash/Ui/splash_screen.dart';
import '../../features/chat/ui/chat_list_screen.dart';
import '../../features/chat/ui/chat_detail_screen.dart';
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
          builder: (_) => ScreenLayout(),
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
      // case AppRoutes.seeAllFields:
      //   final fields = settings.arguments as List<Map<String, String>>;
      //   return MaterialPageRoute(
      //     builder: (_) => FieldsScreen(fields: fields),
      //   );
      // case AppRoutes.seeAllNotes:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => NotesScreen(
      //       notes: args['notes'] as List<Map<String, String>>,
      //       onAddNote: args['onAddNote'] as VoidCallback,
      //     ),
      //   );
      case AppRoutes.sensorDataScreen:
        return MaterialPageRoute(
          builder: (_) => const SensorDataScreen(
            field: {},
          ),
        );
      // case AppRoutes.addNewNote:
      //   return MaterialPageRoute(
      //     builder: (_) => AddNewNoteScreen(
      //       onSave: (String title, String content) {
      //         debugPrint('Title: $title');
      //         debugPrint('Content: $content');
      //       },
      //     ),
      //   );
      // case AppRoutes.editNoteScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const EditNoteScreen(
      //       noteId: '',
      //       currentContent: '',
      //     ),
      //   );
      case AppRoutes.chatList:
        return MaterialPageRoute(
          builder: (_) => ChatListScreen(),
        );
      case AppRoutes.detectionRecords:
        return MaterialPageRoute(
          builder: (_) => const DetectionRecords(),
        );
      case AppRoutes.chatDetail:
        return MaterialPageRoute(
          builder: (_) => const ChatDetailScreen(),
        );

      case AppRoutes.consultationChat:
        return MaterialPageRoute(
          builder: (_) => const ChatBotScreen(),
        );

      case '/farmAnalytics-chat':
        return MaterialPageRoute(
          builder: (_) => const FarmAnalyticsScreen(),
        );
      case '/cropsManagment-chat':
        return MaterialPageRoute(
          builder: (_) => const CropsManagementScreen(),
        );
      case '/farmInventory-chat':
        return MaterialPageRoute(
          builder: (_) => const FarmInventoryScreen(),
        );
      case '/sensorData':
        return MaterialPageRoute(
          builder: (_) => const SensorDataScreen(
            field: {},
          ),
        );
      case '/team':
        return MaterialPageRoute(
          builder: (_) => const TeamScreen(),
        );
      case '/settingsScreen':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case '/profileScreen':
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case '/editProfileScreen':
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );
      case AppRoutes.cropHealth:
        return MaterialPageRoute(builder: (_) => const CropHealth());
      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case AppRoutes.allTasks:
        return MaterialPageRoute(builder: (_) => const TaskListScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
    }
  }
}
