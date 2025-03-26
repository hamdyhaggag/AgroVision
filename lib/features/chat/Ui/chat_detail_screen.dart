import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dependency_injection/di.dart';
import '../../../shared/widgets/chat_bubble.dart';
import '../Logic/chat_cubit.dart';
import '../chat_repository.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(getIt<ChatRepository>()),
      child: const _ChatDetailView(),
    );
  }
}

class _ChatDetailView extends StatefulWidget {
  const _ChatDetailView();

  @override
  State<_ChatDetailView> createState() => __ChatDetailViewState();
}

class __ChatDetailViewState extends State<_ChatDetailView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showCapabilitiesDialog(),
          ),
        ],
      ),
      // Update the body in ChatDetailScreen
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return ChatBubble(
                      message: message,
                      onLongPress: () => _showMessageOptions(message),
                    );
                  },
                );
              },
            ),
          ),
          _ChatInputField(controller: _controller),
        ],
      ),
    );
  }

  void _showCapabilitiesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assistant Capabilities'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCapabilityItem(Icons.text_fields, 'Text Analysis'),
            _buildCapabilityItem(Icons.image, 'Image Recognition'),
            _buildCapabilityItem(Icons.mic, 'Voice Commands'),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilityItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              context.read<ChatCubit>().deleteMessage(message);
              Navigator.pop(context);
            },
          ),
          if (!message.isSentByMe)
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.text));
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

class _ChatInputField extends StatelessWidget {
  final TextEditingController controller;

  const _ChatInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _AttachmentButton(),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ask about crops...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onSubmitted: (text) => _handleSend(text, context),
            ),
          ),
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return IconButton(
                icon: state is ChatLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send),
                onPressed: () => _handleSend(controller.text, context),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleSend(String text, BuildContext context) {
    if (text.trim().isEmpty) return;
    context.read<ChatCubit>().sendTextMessage(text);
    controller.clear();
  }
}

class _AttachmentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'image',
          child: ListTile(
            leading: Icon(Icons.image),
            title: Text('Send Image'),
          ),
        ),
        const PopupMenuItem(
          value: 'voice',
          child: ListTile(
            leading: Icon(Icons.mic),
            title: Text('Record Voice'),
          ),
        ),
      ],
      onSelected: (value) => _handleAttachment(value, context),
    );
  }

  void _handleAttachment(String value, BuildContext context) {
    switch (value) {
      case 'image':
        _pickImage(context);
        break;
      case 'voice':
        _recordVoice(context);
        break;
    }
  }

  void _pickImage(BuildContext context) async {
    // Implement image picker
  }

  void _recordVoice(BuildContext context) {
    // Implement voice recording
  }
}
