import 'package:agro_vision/features/chat/services/farmer_chat_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/Logic/auth cubit/auth_cubit.dart';
import '../logic/farmer_chat_cubit.dart';
import '../logic/farmer_chat_state.dart';
import '../models/farmer_chat_model.dart';

class FarmerChatScreen extends StatelessWidget {
  final Conversation conversation;
  const FarmerChatScreen({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().currentUser?.id ?? 0;
    if (currentUserId == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(child: Text('User not logged in')),
      );
    }
    return BlocProvider(
      create: (context) => FarmerChatCubit(
        context.read<FarmerChatApiService>(),
      )..loadConversations(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<FarmerChatCubit, FarmerChatState>(
                builder: (context, state) {
                  if (state is FarmerChatLoaded) {
                    final currentConv = state.conversations.firstWhere(
                      (c) => c.id == conversation.id,
                      orElse: () => conversation,
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
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
                color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                'Chat with ${conversation.otherUserId}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withOpacity(0.9),
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.withOpacity(0.8),
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
    return messages.isEmpty
        ? const Center(child: Text('No messages yet'))
        : ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isSentByMe = message.senderId == currentUserId;
              return ListTile(
                title: Text(message.message),
                subtitle: Text(isSentByMe ? 'You' : 'Other'),
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Start chatting with ${conversation.otherUserId}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send your first message to begin',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            'Loading messages...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final textController = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(16).copyWith(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
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
              context.read<FarmerChatCubit>().sendMessage(
                    conversationId: conversation.id,
                    message: textController.text,
                  );
              textController.clear();
            },
          ),
        ),
        maxLines: 3,
        minLines: 1,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSentByMe)
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 14,
              child: Icon(Icons.person, size: 16, color: Colors.grey[600]),
            ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: isSentByMe ? 40 : 8,
                  right: isSentByMe ? 8 : 40,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSentByMe
                      ? Theme.of(context).primaryColor.withOpacity(0.9)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
                    bottomRight: Radius.circular(isSentByMe ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 15,
                        color: isSentByMe ? Colors.white : Colors.grey[800],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message.createdAt),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isSentByMe ? Colors.white70 : Colors.grey[500],
                          ),
                        ),
                        if (isLoading)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    isSentByMe ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: isSentByMe ? null : 0,
                right: isSentByMe ? 0 : null,
                child: CustomPaint(
                  size: const Size(10, 10),
                  painter: BubbleTailPainter(
                    color: isSentByMe
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.9)
                        : Colors.grey[100]!,
                    isSentByMe: isSentByMe,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isSentByMe;

  BubbleTailPainter({required this.color, required this.isSentByMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    if (isSentByMe) {
      // Tail on the right
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      // Tail on the left
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(0, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
