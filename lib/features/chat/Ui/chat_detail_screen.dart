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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Khedr AI',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SYNE',
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Agricultural Assistant',
              style: TextStyle(fontSize: 14, fontFamily: 'SYNE'),
            )
          ],
        ),
        centerTitle: false,
        elevation: 2,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.primaryColor),
            onPressed: () => _showCapabilitiesDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state.messages.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    itemCount: state.messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ChatBubble(
                          message: message,
                          onLongPress: () => _showMessageOptions(message),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          _buildInputSection(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/khedr.jpg',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          const Text('How can I help you today?',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontFamily: 'SYNE',
              )),
          const SizedBox(height: 8),
          Text('Ask about crops, weather, or soil analysis',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 14,
                fontFamily: 'SYNE',
              )),
        ],
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _AttachmentButton(),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: const TextStyle(
                      fontFamily: 'SYNE', color: AppColors.greyColor),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  suffixIcon: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: state is ChatLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send_rounded,
                                color: AppColors.primaryColor),
                        onPressed: () => _handleSend(_controller.text, context),
                      );
                    },
                  ),
                ),
                onSubmitted: (text) => _handleSend(text, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCapabilitiesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assistant Capabilities',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SYNE',
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._buildCapabilityItems(),
              const SizedBox(height: 8),
              const Text('More features coming soon!',
                  style: TextStyle(
                    fontFamily: 'SYNE',
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCapabilityItems() {
    return [
      _buildCapabilityItem(Icons.analytics, 'Crop Analysis',
          'Get detailed insights about crop health and growth'),
      _buildCapabilityItem(Icons.photo_camera, 'Image Recognition',
          'Identify plant diseases from photos'),
      _buildCapabilityItem(Icons.thermostat, 'Weather Prediction',
          'Get localized weather forecasts'),
      _buildCapabilityItem(Icons.science, 'Soil Analysis',
          'Understand soil composition and recommendations'),
    ];
  }

  Widget _buildCapabilityItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SYNE',
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Message Options',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SYNE',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1, color: Colors.grey[300]),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red[400]),
              title: const Text(
                'Delete Message',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SYNE',
                ),
              ),
              onTap: () {
                context.read<ChatCubit>().deleteMessage(message);
                Navigator.pop(context);
              },
            ),
            if (!message.isSentByMe)
              ListTile(
                leading: const Icon(Icons.copy, color: AppColors.primaryColor),
                title: const Text(
                  'Copy to Clipboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SYNE',
                  ),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message copied')),
                  );
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _handleSend(String text, BuildContext context) {
    if (text.trim().isEmpty) return;
    context.read<ChatCubit>().sendTextMessage(text);
    _controller.clear();
  }
}

class _AttachmentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: AppColors.primaryColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'image',
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.image, color: AppColors.primaryColor),
            ),
            title: const Text('Upload Image',
                style: TextStyle(
                    color: AppColors.textPrimary, fontFamily: 'SYNE')),
            subtitle: const Text('JPG, PNG up to 5MB',
                style: TextStyle(
                    color: AppColors.textSecondary, fontFamily: 'SYNE')),
          ),
        ),
        PopupMenuItem(
          value: 'voice',
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: AppColors.primaryColor),
            ),
            title: const Text('Voice Message',
                style: TextStyle(
                    color: AppColors.textPrimary, fontFamily: 'SYNE')),
            subtitle: const Text('Press to record',
                style: TextStyle(
                    color: AppColors.textSecondary, fontFamily: 'SYNE')),
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

  void _pickImage(BuildContext context) async {}

  void _recordVoice(BuildContext context) {}
}
