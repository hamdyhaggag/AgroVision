import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings '),
      body: Center(
        child: Text('Settings Screen',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
