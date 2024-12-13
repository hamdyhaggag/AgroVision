import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class FarmInventoryScreen extends StatelessWidget {
  const FarmInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Inventory'),
      body: Center(
        child: Text('Farm Inventory Screen',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
