import 'dart:ui' as ui;

import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/features/chat/services/farmer_chat_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../authentication/Logic/auth cubit/auth_cubit.dart';
import '../logic/farmer_chat_cubit.dart';
import '../logic/farmer_chat_state.dart';
import '../models/farmer_chat_model.dart';

class FarmerChatScreen extends StatefulWidget {
  final Conversation conversation;

  const FarmerChatScreen({
    super.key,
    required this.conversation,
  });

  @override
  _FarmerChatScreenState createState() => _FarmerChatScreenState();
}

class _FarmerChatScreenState extends State<FarmerChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FarmerChatCubit>().loadConversations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat with ${widget.conversation.otherUserId}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withValues(alpha: 0.9),
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessagesList(List<Message> messages, int currentUserId) {
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (messages.isEmpty) {
      return const Center(child: Text('No messages yet'));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSentByMe = message.senderId == currentUserId;
        return ChatBubble(
          message: message,
          onLongPress: () {},
          isLoading: false,
          isSentByMe: isSentByMe,
        );
      },
    );
  }

  Widget _buildMessageInput(int conversationId) {
    return Container(
      margin: const EdgeInsets.all(16).copyWith(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintStyle: TextStyles.size16GaryRegular,
          hintText: 'Type your message...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            icon:
                Icon(Icons.send_rounded, color: Theme.of(context).primaryColor),
            onPressed: () {
              final currentUserId =
                  context.read<AuthCubit>().currentUser?.id ?? 0;
              if (currentUserId != 0) {
                context.read<FarmerChatCubit>().sendMessage(
                      conversationId: conversationId,
                      message: _textController.text,
                      senderId: currentUserId,
                    );
                _textController.clear();
              }
            },
          ),
        ),
        maxLines: 3,
        minLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is UserUpdatedState) {
          final currentUserId = context.read<AuthCubit>().currentUser?.id ?? 0;
          if (currentUserId == 0) {
            return _buildLoginPrompt();
          }

          return BlocProvider(
            create: (context) => FarmerChatCubit(
              context.read<FarmerChatApiService>(),
            )..loadConversations(),
            child: _buildChatInterface(currentUserId),
          );
        }

        if (authState is UserClearedState) {
          return _buildLoginPrompt();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildChatInterface(int currentUserId) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<FarmerChatCubit, FarmerChatState>(
              builder: (context, state) {
                if (state is FarmerChatLoaded) {
                  final currentConv = state.conversations.firstWhere(
                    (c) => c.id == widget.conversation.id,
                    orElse: () => widget.conversation,
                  );
                  return _buildMessagesList(
                      currentConv.messages, currentUserId);
                } else if (state is FarmerChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FarmerChatError) {
                  return Center(child: Text(state.errorMessage));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _buildMessageInput(widget.conversation.id),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('Please login to continue')),
    );
  }
}

class ChatBubble extends StatefulWidget {
  final Message message;
  final VoidCallback onLongPress;
  final bool isLoading;
  final bool isSentByMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onLongPress,
    this.isLoading = false,
    required this.isSentByMe,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    for (var i = 0; i < 3; i++) {
      _dotAnimations.add(
        Tween<double>(begin: 1.0, end: 1.4).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.2 * i, 0.2 * i + 0.4, curve: Curves.easeInOut),
          ),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant ChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _initializeAnimations();
      } else {
        _controller.dispose();
        _dotAnimations.clear();
      }
    }
  }

  @override
  void dispose() {
    if (widget.isLoading) _controller.dispose();
    super.dispose();
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _dotAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _dotAnimations[index].value,
              child: child,
            );
          },
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: widget.isSentByMe ? Colors.white70 : Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: widget.isSentByMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!widget.isSentByMe)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 14,
                  child: Icon(Icons.person, size: 16, color: Colors.grey[600]),
                ),
              ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isSentByMe
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Text(
                        widget.message.message,
                        style: TextStyle(
                          fontSize:
                              isArabic(widget.message.message) ? 15.0 : 16.0,
                          fontFamily:
                              isArabic(widget.message.message) ? 'DIN' : 'SYNE',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            DateFormat('HH:mm')
                                .format(widget.message.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.isLoading)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: _buildTypingIndicator(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
