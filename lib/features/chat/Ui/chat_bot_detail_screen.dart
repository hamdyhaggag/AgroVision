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

class _ChatBotDetailScreenState extends State<ChatBotDetailScreen>
    with SingleTickerProviderStateMixin {
  late bool _isInputArabic = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  void initState() {
    super.initState();
    _handleSessionAndPrefill();
    _controller.addListener(_checkInputLanguage);
    _setupTypingAnimation();
  }

  void _setupTypingAnimation() {
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
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

  void _checkInputLanguage() {
    final currentText = _controller.text;
    final isArabicText = isArabic(currentText);
    if (isArabicText != _isInputArabic) {
      setState(() => _isInputArabic = isArabicText);
    }
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _controller.removeListener(_checkInputLanguage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatNetworkError) {
          String errorMessage = state.error;
          IconData errorIcon = Icons.cloud_off;
          Color errorColor = Colors.orange[800]!;

          if (state.error.contains('ERR_NGROK') ||
              state.error.contains('ngrok') ||
              state.error.contains('offline') ||
              state.error.contains('connection') ||
              state.error.contains('network')) {
            errorMessage =
                'The AI service is currently unavailable. Please try again later.';
          } else if (state.error.contains('timed out')) {
            errorMessage =
                'The AI service is taking longer than expected to respond. Please try again.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(errorIcon, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(errorMessage)),
                  if (state.pendingMessages.isNotEmpty)
                    TextButton(
                      child: const Text('RETRY'),
                      onPressed: () =>
                          context.read<ChatCubit>().retryPendingMessages(),
                    ),
                ],
              ),
              backgroundColor: errorColor,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.2),
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
                      color: AppColors.textPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    'Agricultural Assistant',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SYNE',
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
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
                color: AppColors.primaryColor.withValues(alpha: 0.8),
              ),
              onPressed: _showCapabilitiesDialog,
            ),
          ],
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatError) {
              final isServerOffline =
                  state.error.toLowerCase().contains('offline') ||
                      state.error.toLowerCase().contains('connection') ||
                      state.error.toLowerCase().contains('network') ||
                      state.error.toLowerCase().contains('ngrok') ||
                      state.error.toLowerCase().contains('timed out');

              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.95),
                    ],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.cloud_off,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Service Temporarily Unavailable',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: -0.5,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'We\'re currently experiencing technical difficulties with our AI service. Our team has been notified and is working to resolve the issue.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                      height: 1.6,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Please try again in a few moments.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.maybePop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              label: Text(
                                'Go Back',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<ChatCubit>().createNewSession();
                              },
                              icon: const Icon(
                                Icons.refresh,
                                size: 20,
                              ),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

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
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
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
                                _pendingMessagesCount(currentSession.id),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final chatCubit = context.read<ChatCubit>();
                              final pendingMessages = chatCubit.pendingMessages
                                  .where(
                                      (m) => m.sessionId == currentSession.id)
                                  .toList();
                              final allMessages = [
                                ...currentSession.messages,
                                ...pendingMessages
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
                              return const SizedBox.shrink();
                            },
                          ),
                  ),
                ),
                if (state is ChatLoading) _buildTypingIndicator(),
                _buildInputSection(context),
              ],
            );
          },
        ),
      ),
    );
  }

  int _pendingMessagesCount(String sessionId) {
    return context
        .read<ChatCubit>()
        .pendingMessages
        .where((m) => m.sessionId == sessionId)
        .length;
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
                textDirection:
                    _isInputArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  fontFamily: _isInputArabic ? 'DIN' : 'SYNE',
                  fontSize: _isInputArabic ? 15.0 : 16.0,
                ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/khedr.jpg', width: 80, height: 80),
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

  void _handleSend(String text, BuildContext context) {
    if (text.trim().isEmpty) return;
    final chatCubit = context.read<ChatCubit>();

    chatCubit.sendTextMessage(text);

    _controller.clear();
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
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCapabilityItems() {
    return [
      _buildCapabilityItem(Icons.analytics, 'Crop Analysis',
          'Get detailed insights about crop health'),
      _buildCapabilityItem(Icons.photo_camera, 'Image Recognition',
          'Identify plant diseases from photos'),
      _buildCapabilityItem(Icons.thermostat, 'Weather Prediction',
          'Get localized weather forecasts'),
      _buildCapabilityItem(
          Icons.science, 'Soil Analysis', 'Understand soil composition'),
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
              title: const Text('Delete',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  )),
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

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/khedr.jpg'),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _typingAnimation,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(
                        0.3 + (_typingAnimation.value * 0.7),
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              );
            }),
          ),
        ],
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
                Text("Record Voice Message",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SYNE',
                      fontWeight: FontWeight.bold,
                    )),
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
                child: Text('Image Question',
                    style: TextStyle(fontFamily: 'SYNE'))),
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
                child:
                    const Text('Cancel', style: TextStyle(fontFamily: 'SYNE')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, textController.text),
                child: const Text('Send', style: TextStyle(fontFamily: 'SYNE')),
              ),
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
  void initState() {
    super.initState();
    _voiceRecorder.init();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      _recordedFilePath = await _voiceRecorder.stopRecording();
      setState(() => _isRecording = false);
      if (_recordedFilePath != null) {
        context.read<ChatCubit>().sendVoiceMessage(
              File(_recordedFilePath!),
              speak: 'true',
              language: 'auto',
            );
        Navigator.pop(context);
      }
    } else {
      _recordedFilePath = await _voiceRecorder.startRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  void dispose() {
    _voiceRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isRecording ? Icons.stop : Icons.mic),
      onPressed: _toggleRecording,
    );
  }
}
