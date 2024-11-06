import 'package:flutter/material.dart';

class MonitoringScreen extends StatelessWidget {
  static const String routeName = '/monitoring';

  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Monitoring Screen')),
    );
  }
}
