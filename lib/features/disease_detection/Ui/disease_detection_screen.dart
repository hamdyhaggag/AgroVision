import 'package:flutter/material.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  static const String routeName = '/disease_detection';

  const DiseaseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Disease Detection Screen')),
    );
  }
}
