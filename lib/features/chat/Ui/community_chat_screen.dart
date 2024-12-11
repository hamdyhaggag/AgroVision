import 'package:flutter/material.dart';

import 'chat_detail_screen.dart';

class CommunityChatScreen extends StatelessWidget {
  const CommunityChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: const ChatDetailScreen(),
    );
  }
}
