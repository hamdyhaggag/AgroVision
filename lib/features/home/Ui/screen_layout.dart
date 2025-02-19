import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/themes/app_colors.dart';
import '../../chat/Ui/chat_list_screen.dart';
import '../../disease_detection/Ui/detection_records.dart';
import '../../disease_detection/Ui/plant_details_screen.dart';
import '../../monitoring/UI/sensor_data_screen.dart';
import '../../splash/Logic/app_cubit.dart';
import '../../splash/Logic/app_state.dart';
import 'home_screen.dart';

class ScreenLayout extends StatelessWidget {
  ScreenLayout({super.key});
  final _navItems = [
    const BottomNavItem(
      type: NavItem.home,
      iconPath: 'assets/icon/home_icon.svg',
      label: 'Home',
    ),
    const BottomNavItem(
      type: NavItem.detect,
      iconPath: 'assets/icon/camera.svg',
      label: 'Detect',
      hasAction: true,
    ),
    const BottomNavItem(
      type: NavItem.sensor,
      iconPath: 'assets/icon/history_icon.svg',
      label: 'History',
    ),
    const BottomNavItem(
      type: NavItem.chat,
      iconPath: 'assets/icon/chat_icon.svg',
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
          final currentIndex = cubit.bottomNavIndex;
          return Scaffold(
            body: _buildScreen(currentIndex),
            bottomNavigationBar: _CustomBottomNavBar(
              items: _navItems,
              currentIndex: currentIndex,
              onItemSelected: (index) => _handleNavSelection(context, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScreen(int index) {
    final screens = [
      const HomeScreen(),
      const DetectionRecords(),
      const SensorDataScreen(
        field: {},
      ),
      ChatListScreen(),
    ];
    return IndexedStack(index: index, children: screens);
  }

  void _handleNavSelection(BuildContext context, int index) {
    final cubit = context.read<AppCubit>();
    final item = _navItems[index];
    if (item.hasAction) {
      _showImagePickerBottomSheet(context);
    } else {
      cubit.changeBottomNavIndex(index);
    }
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetContext) =>
            PlantSelectionFlow(onImageSelected: (path, plant) {
              Navigator.pop(sheetContext);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlantDetailsScreen(
                    imagePath: path,
                    selectedPlant: plant,
                  ),
                ),
              );
            }));
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  const _CustomBottomNavBar({
    required this.items,
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
        items: items.map((item) => _buildNavItem(item, context)).toList(),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      BottomNavItem item, BuildContext context) {
    final isActive = items.indexOf(item) == currentIndex;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(isActive ? 1.2 : 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.iconPath,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.primaryColor : AppColors.greyColor,
                BlendMode.srcIn,
              ),
              width: 30,
              height: 30,
            ),
            if (isActive)
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
    );
  }
}

class PlantSelectionFlow extends StatefulWidget {
  final Function(String, String) onImageSelected;
  const PlantSelectionFlow({super.key, required this.onImageSelected});

  @override
  State<PlantSelectionFlow> createState() => _PlantSelectionFlowState();
}

class _PlantSelectionFlowState extends State<PlantSelectionFlow> {
  String? _selectedPlant;
  final _picker = ImagePicker();

  void _handleImagePick(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source, imageQuality: 85);
      if (image != null && _selectedPlant != null && context.mounted) {
        widget.onImageSelected(image.path, _selectedPlant!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _selectedPlant == null
          ? _PlantSelectionGrid(
              key: const ValueKey("grid"),
              onPlantSelected: (plant) =>
                  setState(() => _selectedPlant = plant),
            )
          : _ImageSourcePicker(
              key: const ValueKey("picker"),
              plant: _selectedPlant!,
              onSourceSelected: _handleImagePick,
              onBack: () => setState(() => _selectedPlant = null),
            ),
    );
  }
}

class _PlantSelectionGrid extends StatelessWidget {
  final Function(String) onPlantSelected;
  const _PlantSelectionGrid({super.key, required this.onPlantSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Select Plant Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                    fontFamily: 'SYNE',
                  ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _PlantSelectionCard(
                plant: 'Tomato',
                icon: 'assets/images/tomato.png',
                color: Colors.red[100]!,
                onTap: onPlantSelected,
              ),
              _PlantSelectionCard(
                plant: 'Potato',
                icon: 'assets/images/potato.png',
                color: Colors.brown[100]!,
                onTap: onPlantSelected,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImageSourcePicker extends StatelessWidget {
  final String plant;
  final Function(ImageSource) onSourceSelected;
  final VoidCallback onBack;
  const _ImageSourcePicker({
    super.key,
    required this.plant,
    required this.onSourceSelected,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              Text(
                'Select Source for $plant',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SYNE',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SourceButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => onSourceSelected(ImageSource.gallery),
              ),
              _SourceButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => onSourceSelected(ImageSource.camera),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

class _PlantSelectionCard extends StatelessWidget {
  final String plant;
  final String icon;
  final Color color;
  final Function(String) onTap;
  const _PlantSelectionCard({
    required this.plant,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(plant),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(icon),
              ),
              const SizedBox(width: 12),
              Text(
                plant,
                style: const TextStyle(
                  fontFamily: 'SYNE',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          iconSize: 32,
          onPressed: onTap,
          icon: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontFamily: 'SYNE'),
        ),
      ],
    );
  }
}

enum NavItem { home, detect, sensor, chat }
