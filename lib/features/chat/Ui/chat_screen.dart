import 'package:agro_vision/features/chat/services/farmer_chat_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../logic/farmer_chat_cubit.dart';
import '../logic/farmer_chat_state.dart';
import '../models/farmer_chat_model.dart';

class FarmerChatScreen extends StatelessWidget {
  final Conversation conversation;
  final int currentUserId;
  const FarmerChatScreen({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FarmerChatCubit(
        context.read<FarmerChatApiService>(),
      )..loadConversations(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat with ${conversation.otherUserId}'),
        ),
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
                    return _buildMessagesList(currentConv.messages);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(List<Message> messages) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(
          message: message,
          isMe: message.senderId == currentUserId,
        );
      },
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final textController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              context.read<FarmerChatCubit>().sendMessage(
                    conversationId: conversation.id,
                    message: textController.text,
                  );
              textController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.message),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (isMe && message.isRead == 1)
                  const Icon(Icons.done_all, size: 12, color: Colors.blue)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
