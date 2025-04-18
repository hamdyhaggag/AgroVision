import 'dart:async';
import 'dart:io';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/helpers/voice_recorder_utility.dart';
import '../../../models/chat_session.dart';
import '../../../shared/widgets/chat_bubble.dart';
import '../logic/chat_cubit.dart';

class ChatBotDetailScreen extends StatefulWidget {
  const ChatBotDetailScreen({super.key});

  @override
  State<ChatBotDetailScreen> createState() => _ChatBotDetailScreenState();
}

class _ChatBotDetailScreenState extends State<ChatBotDetailScreen> {
  int _getPendingMessagesCount(String sessionId) {
    final chatCubit = context.read<ChatCubit>();
    return chatCubit.pendingMessages
        .where((m) => m.sessionId == sessionId)
        .length;
  }

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _handleSessionAndPrefill();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is Map<String, dynamic>) {
        final prefillMessage = routeArgs['prefillMessage'] as String?;
        if (prefillMessage != null && prefillMessage.isNotEmpty) {
          _controller.text = prefillMessage;
        }
      }
    });
  }

  void _handleSessionAndPrefill() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is! Map<String, dynamic>) return;
      if (routeArgs['newSession'] == true) {
        final chatCubit = context.read<ChatCubit>();
        await _ensureNewSession(chatCubit);
      }
      final prefillMessage = routeArgs['prefillMessage'] as String?;
      if (prefillMessage != null && prefillMessage.isNotEmpty) {
        _controller.text = prefillMessage;
      }
    });
  }

  Future<void> _ensureNewSession(ChatCubit chatCubit) async {
    if (chatCubit.state.sessions.isEmpty ||
        chatCubit.state.currentSessionId == null) {
      await chatCubit.createNewSession();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatNetworkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.error)),
                  TextButton(
                    child: const Text('RETRY'),
                    onPressed: () =>
                        context.read<ChatCubit>().retryPendingMessages(),
                  ),
                ],
              ),
              backgroundColor: Colors.red[800],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Add your prefix icon here
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            },
          ),

          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/khedr.jpg'),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khedr AI',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SYNE',
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    'Agricultural Assistant',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SYNE',
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: AppColors.primaryColor.withOpacity(0.8),
              ),
              onPressed: _showCapabilitiesDialog,
            ),
          ],
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            final currentSession = state.sessions.firstWhere(
              (s) => s.id == state.currentSessionId,
              orElse: () => ChatSession(
                id: 'default',
                messages: [],
                createdAt: DateTime.now(),
              ),
            );

            return Column(
              children: [
                Expanded(
                  child: BlocListener<ChatCubit, ChatState>(
                      listener: (context, state) {
                        if (currentSession.messages.isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        }
                      },
                      child: currentSession.messages.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              itemCount: currentSession.messages.length +
                                  (state is ChatLoading ? 1 : 0) +
                                  _getPendingMessagesCount(currentSession.id),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final chatCubit = context.read<ChatCubit>();
                                final pendingMessages = chatCubit
                                    .pendingMessages
                                    .where(
                                        (m) => m.sessionId == currentSession.id)
                                    .toList();
                                final allMessages = [
                                  ...currentSession.messages,
                                  ...pendingMessages,
                                ];
                                if (index < allMessages.length) {
                                  final message = allMessages[index];
                                  return ChatBubble(
                                    message: message,
                                    isLoading:
                                        message.status == MessageStatus.pending,
                                    onLongPress: () =>
                                        _showMessageOptions(message),
                                  );
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ChatBubble(
                                    message: Message(
                                      text: '',
                                      isSentByMe: false,
                                      timestamp: DateTime.now(),
                                    ),
                                    isLoading: true,
                                    loadingColor: AppColors.primaryColor,
                                    onLongPress: () {},
                                  ),
                                );
                              },
                            )),
                ),
                _buildInputSection(context),
              ],
            );
          },
        ),
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
          const _AttachmentButton(),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
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
                        key: const ValueKey('send'),
                        icon: const Icon(Icons.send_rounded,
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

  void _handleSend(String text, BuildContext context) {
    if (text.trim().isEmpty) return;
    final chatCubit = context.read<ChatCubit>();
    final currentSession = chatCubit.state.sessions.firstWhere(
      (s) => s.id == chatCubit.state.currentSessionId,
      orElse: () => ChatSession(
        id: 'default',
        messages: [],
        createdAt: DateTime.now(),
      ),
    );
    if (currentSession.messages.isEmpty) {
      chatCubit.createNewSession().then((_) {
        chatCubit.sendTextMessage(text);
      });
    } else {
      chatCubit.sendTextMessage(text);
    }
    _controller.clear();
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                context.read<ChatCubit>().deleteMessage(message);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton();

  void _handleAttachment(String value, BuildContext context) {
    switch (value) {
      case 'image':
        _pickImage(context);
        break;
      case 'voice':
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Record Voice Message",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SYNE',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                VoiceRecordingWidget(),
              ],
            ),
          ),
        );
        break;
    }
  }

  void _pickImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (pickedFile != null) {
      final question = await showDialog<String>(
        context: context,
        builder: (context) {
          final textController = TextEditingController();
          return AlertDialog(
            title: const Center(
              child:
                  Text('Image Question', style: TextStyle(fontFamily: 'SYNE')),
            ),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Ask about this image...',
                hintStyle: TextStyle(fontFamily: 'SYNE', color: Colors.grey),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(fontFamily: 'SYNE'))),
              TextButton(
                  onPressed: () => Navigator.pop(context, textController.text),
                  child:
                      const Text('Send', style: TextStyle(fontFamily: 'SYNE'))),
            ],
          );
        },
      );
      if (question?.isNotEmpty ?? false) {
        context.read<ChatCubit>().sendImageMessage(
              File(pickedFile.path),
              question!,
              'text',
              'false',
            );
      }
    }
  }

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
}

class VoiceRecordingWidget extends StatefulWidget {
  const VoiceRecordingWidget({super.key});

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget> {
  final VoiceRecorder _voiceRecorder = VoiceRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void dispose() {
    _voiceRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _voiceRecorder.stopRecording();
      setState(() => _isRecording = false);
      if (_recordedFilePath != null) {
        context.read<ChatCubit>().sendVoiceMessage(
              File(_recordedFilePath!),
              speak: 'false',
              language: 'en',
            );
        Navigator.pop(context);
      }
    } else {
      final filePath = await _voiceRecorder.startRecording();
      setState(() {
        _isRecording = true;
        _recordedFilePath = filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isRecording ? Icons.stop : Icons.mic),
      onPressed: _toggleRecording,
    );
  }
}
