import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/themes/app_colors.dart';
import '../../chat/Ui/chat_list_screen.dart';
import '../../disease_detection/Ui/detection_records.dart';
import '../../disease_detection/Ui/plant_details_screen.dart';
import '../../disease_detection/Ui/widgets/image_source_picker.dart';
import '../../disease_detection/Ui/widgets/plant_button.dart';
import '../../monitoring/UI/sensor_data_screen.dart';
import '../../splash/Logic/app_cubit.dart';
import '../../splash/Logic/app_state.dart';
import 'home_screen.dart';

enum NavItem { home, detect, sensor, chat }

class BottomNavItem {
  final NavItem type;
  final String iconPath;
  final String label;
  final bool hasAction;

  const BottomNavItem({
    required this.type,
    required this.iconPath,
    required this.label,
    this.hasAction = false,
  });
}

final List<String> availablePlants = [
  'Tomato',
  'Potato',
];

void _showPlantSelectionDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Select Plant Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SYNE',
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PlantButton(
                imagePath: 'assets/images/tomato.png',
                label: 'Tomato',
                onPressed: () {
                  Navigator.pop(ctx);
                  _showImagePickerBottomSheet(context, 'tomato');
                },
              ),
              PlantButton(
                imagePath: 'assets/images/potato.png',
                label: 'Potato',
                onPressed: () {
                  Navigator.pop(ctx);
                  _showImagePickerBottomSheet(context, 'potato');
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showImagePickerBottomSheet(BuildContext context, String plantType) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => ImageSourcePicker(
      onImageSelected: (path) {
        Navigator.pop(sheetContext);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlantDetailsScreen(
              imagePath: path,
              plantType: plantType,
            ),
          ),
        );
      },
    ),
  );
}

class ScreenLayout extends StatelessWidget {
  const ScreenLayout({super.key});

  static const _navItems = [
    BottomNavItem(
      type: NavItem.home,
      iconPath: 'assets/icon/home.svg',
      label: 'Home',
    ),
    BottomNavItem(
      type: NavItem.detect,
      iconPath: 'assets/icon/ai-scan.svg',
      label: 'Detect',
      hasAction: true,
    ),
    BottomNavItem(
      type: NavItem.sensor,
      iconPath: 'assets/icon/analytics_icon.svg',
      label: 'Analytics',
    ),
    BottomNavItem(
      type: NavItem.chat,
      iconPath: 'assets/icon/bubble-chat.svg',
      label: 'Chat',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          final cubit = context.read<AppCubit>();
          return Scaffold(
            body: _ScreenSwitcher(index: cubit.bottomNavIndex),
            bottomNavigationBar: _CustomBottomNavBar(
              currentIndex: cubit.bottomNavIndex,
              onItemSelected: (index) => _handleNavSelection(context, index),
            ),
          );
        },
      ),
    );
  }

  void _handleNavSelection(BuildContext context, int index) {
    final cubit = context.read<AppCubit>();
    final item = _navItems[index];

    if (item.hasAction) {
      _showPlantSelectionDialog(context);
    } else {
      cubit.changeBottomNavIndex(index);
    }
  }
}

class _ScreenSwitcher extends StatelessWidget {
  final int index;
  const _ScreenSwitcher({required this.index});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: const [
        HomeScreen(),
        DetectionRecords(),
        SensorDataScreen(field: {}),
        ChatListScreen(),
      ],
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onItemSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.greyLight,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.greyColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: ScreenLayout._navItems
            .map((item) => BottomNavigationBarItem(
                  icon: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: ScreenLayout._navItems.indexOf(item) == currentIndex
                        ? 1.2
                        : 1.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          item.iconPath,
                          colorFilter: ColorFilter.mode(
                            ScreenLayout._navItems.indexOf(item) == currentIndex
                                ? AppColors.primaryColor
                                : AppColors.greyColor,
                            BlendMode.srcIn,
                          ),
                          width: 28,
                          height: 28,
                        ),
                        if (ScreenLayout._navItems.indexOf(item) ==
                            currentIndex)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}
