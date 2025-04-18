import 'dart:async';
import 'dart:ui' as ui;
import 'package:agro_vision/core/themes/text_styles.dart';
import 'package:agro_vision/features/chat/services/farmer_chat_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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

class _FarmerChatScreenState extends State<FarmerChatScreen>
    with TickerProviderStateMixin {
  late bool _isInputArabic = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  late AnimationController _typingController;
  late List<Animation<double>> _dotAnimations;
  late final StreamSubscription<FarmerChatState> _sub;
  int _lastMessageCount = 0;

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _dotAnimations = List.generate(3, (i) {
      return Tween<double>(begin: 1.0, end: 1.4).animate(
        CurvedAnimation(
          parent: _typingController,
          curve: Interval(0.2 * i, 0.2 * i + 0.4, curve: Curves.easeInOut),
        ),
      );
    });
    final cubit = context.read<FarmerChatCubit>();
    cubit.loadConversations();
    _sub = cubit.stream.listen((state) {
      if (state is FarmerChatLoaded) {
        final conv = state.conversations
            .firstWhere((c) => c.id == widget.conversation.id);
        if (conv.messages.length > _lastMessageCount) {
          _lastMessageCount = conv.messages.length;
          _scrollToBottom();
        }
      }
    });
    _textController.addListener(_checkInputLanguage);
  }

  void _checkInputLanguage() {
    final currentText = _textController.text;
    final isArabicText = isArabic(currentText);
    if (isArabicText != _isInputArabic) {
      setState(() => _isInputArabic = isArabicText);
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    _typingController.dispose();
    _scrollController.dispose();
    _textController.dispose();
    _textController.removeListener(_checkInputLanguage);
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
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.conversation.user1Name,
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
    if (messages.isEmpty) return const Center(child: Text('No messages yet'));
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final m = messages[i];
        final sentByMe = m.senderId == currentUserId;
        return ChatBubble(
          message: m,
          onLongPress: () {},
          isLoading: false,
          isSentByMe: sentByMe,
        );
      },
    );
  }

  Widget _buildChatShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, i) {
          final sentByMe = i % 2 == 0;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment:
                  sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!sentByMe)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
        textDirection:
            _isInputArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        style: TextStyle(
          fontFamily: _isInputArabic ? 'DIN' : 'SYNE',
          fontSize: _isInputArabic ? 15.0 : 16.0,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyles.size16GaryRegular.copyWith(fontFamily: 'SYNE'),
          hintText: 'Type your message...',
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: IconButton(
            icon:
                Icon(Icons.send_rounded, color: Theme.of(context).primaryColor),
            onPressed: () {
              final uid = context.read<AuthCubit>().currentUser?.id ?? 0;
              if (uid != 0) {
                context.read<FarmerChatCubit>().sendMessage(
                      conversationId: conversationId,
                      message: _textController.text,
                      senderId: uid,
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
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      if (authState is UserUpdatedState) {
        final uid = context.read<AuthCubit>().currentUser?.id ?? 0;
        if (uid == 0) return _buildLoginPrompt();
        return BlocProvider(
          create: (ctx) => FarmerChatCubit(ctx.read<FarmerChatApiService>())
            ..loadConversations(),
          child: Scaffold(
            appBar: _buildAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<FarmerChatCubit, FarmerChatState>(
                    builder: (ctx, state) {
                      if (state is FarmerChatLoaded) {
                        final conv = state.conversations.firstWhere(
                          (c) => c.id == widget.conversation.id,
                          orElse: () => widget.conversation,
                        );
                        return _buildMessagesList(conv.messages, uid);
                      } else if (state is FarmerChatError) {
                        return Center(child: Text(state.errorMessage));
                      } else {
                        return _buildChatShimmerLoader();
                      }
                    },
                  ),
                ),
                _buildMessageInput(widget.conversation.id),
              ],
            ),
          ),
        );
      } else if (authState is UserClearedState) {
        return _buildLoginPrompt();
      }
      return const Center(child: CircularProgressIndicator());
    });
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

class _ChatBubbleState extends State<ChatBubble> {
  bool isArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: context
              .findAncestorStateOfType<_FarmerChatScreenState>()!
              ._typingController,
          builder: (ctx, child) {
            final anim = context
                .findAncestorStateOfType<_FarmerChatScreenState>()!
                ._dotAnimations[i];
            return Transform.scale(scale: anim.value, child: child);
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

  @override
  Widget build(BuildContext context) {
    final isArabicText = isArabic(widget.message.message);
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
                  radius: 22,
                  child: Icon(Icons.person, size: 24, color: Colors.grey[600]),
                ),
              ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
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
                      textDirection: isArabicText
                          ? ui.TextDirection.rtl
                          : ui.TextDirection.ltr,
                      child: Text(
                        widget.message.message,
                        style: TextStyle(
                          fontSize: isArabicText ? 15.0 : 16.0,
                          fontFamily: isArabicText ? 'DIN' : 'SYNE',
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
