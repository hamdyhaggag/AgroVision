// consultation_chat_screen.dart
import 'package:flutter/material.dart';

import 'chat_detail_screen.dart';

class ConsultationChatScreen extends StatelessWidget {
  const ConsultationChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatDetailScreen(),
    );
  }
}
