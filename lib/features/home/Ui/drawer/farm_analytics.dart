import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class FarmAnalyticsScreen extends StatelessWidget {
  const FarmAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Analytics'),
      body: Center(
        child: Text('Farm Analytics Screen',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
