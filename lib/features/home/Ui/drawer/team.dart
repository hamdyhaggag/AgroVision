import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Team'),
      body: Center(
        child: Text('Team Screen',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
