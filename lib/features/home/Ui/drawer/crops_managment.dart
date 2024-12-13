import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CropsManagementScreen extends StatelessWidget {
  const CropsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Crops Management'),
      body: Center(
        child: Text('Crops Management Screen',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
