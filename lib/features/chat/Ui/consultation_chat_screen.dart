import 'package:flutter/material.dart';

import 'chat_detail_screen.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatDetailScreen(),
    );
  }
}
