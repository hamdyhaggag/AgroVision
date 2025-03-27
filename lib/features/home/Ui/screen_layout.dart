import 'dart:io';

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
      builder: (sheetContext) => PlantSelectionFlow(
        onImageSelected: (path, plant) {
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
        },
      ),
    );
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
      decoration: _navBarDecoration,
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
            .map((item) => _buildNavItem(item, context))
            .toList(),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      BottomNavItem item, BuildContext context) {
    final isActive = ScreenLayout._navItems.indexOf(item) == currentIndex;
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: isActive ? 1.2 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.iconPath,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.primaryColor : AppColors.greyColor,
                BlendMode.srcIn,
              ),
              width: 28,
              height: 28,
            ),
            if (isActive) _ActiveIndicator(),
          ],
        ),
      ),
      label: item.label,
    );
  }

  BoxDecoration get _navBarDecoration => BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      );
}

class _ActiveIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PlantSelectionFlow extends StatefulWidget {
  final Function(String, String) onImageSelected;

  const PlantSelectionFlow({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<PlantSelectionFlow> createState() => _PlantSelectionFlowState();
}

class _PlantSelectionFlowState extends State<PlantSelectionFlow> {
  String? _selectedPlant;
  final _picker = ImagePicker();
  final _plantOptions = const [
    _PlantData('Tomato', 'assets/images/tomato.png', Colors.red),
    _PlantData('Potato', 'assets/images/potato.png', Colors.brown),
  ];

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null && _selectedPlant != null) {
        widget.onImageSelected(File(image.path).path, _selectedPlant!);
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
              plants: _plantOptions,
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

class _PlantData {
  final String name;
  final String assetPath;
  final Color themeColor;

  const _PlantData(this.name, this.assetPath, this.themeColor);
}

class _PlantSelectionGrid extends StatelessWidget {
  final List<_PlantData> plants;
  final Function(String) onPlantSelected;

  const _PlantSelectionGrid({
    super.key,
    required this.plants,
    required this.onPlantSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildPlantGrid(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Center(
      child: Text(
        'Select Plant Type',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
              fontFamily: 'SYNE',
            ),
      ),
    );
  }

  Widget _buildPlantGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) => _PlantSelectionCard(
        plant: plants[index],
        onTap: onPlantSelected,
      ),
    );
  }
}

class _PlantSelectionCard extends StatelessWidget {
  final _PlantData plant;
  final Function(String) onTap;

  const _PlantSelectionCard({
    required this.plant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(plant.name),
        splashColor: plant.themeColor.withAlpha(50),
        highlightColor: plant.themeColor.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _PlantIcon(assetPath: plant.assetPath, color: plant.themeColor),
              const SizedBox(width: 12),
              Text(
                plant.name,
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

class _PlantIcon extends StatelessWidget {
  final String assetPath;
  final Color color;

  const _PlantIcon({
    required this.assetPath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withAlpha(70),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Image.asset(assetPath),
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
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildSourceButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: 'Back',
        ),
        Expanded(
          child: Text(
            'Select Source for $plant',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SYNE',
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceButtons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SourceButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          source: ImageSource.gallery,
        ),
        _SourceButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          source: ImageSource.camera,
        ),
      ],
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ImageSource source;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          iconSize: 32,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          onPressed: () => context
              .findAncestorStateOfType<_PlantSelectionFlowState>()
              ?._handleImagePick(source),
          icon: Icon(
            icon,
            color: AppColors.whiteColor,
          ),
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
