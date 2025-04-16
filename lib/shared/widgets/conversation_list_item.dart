import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/chat/Ui/chat_screen.dart';
import '../../features/chat/models/farmer_chat_model.dart';

class ConversationListItem extends StatelessWidget {
  final Conversation conversation;
  final int currentUserId;

  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final lastMessage =
        conversation.messages.isNotEmpty ? conversation.messages.last : null;

    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/farmer_avatar.png'),
      ),
      title: Text('User ${conversation.otherUserId}'),
      subtitle: Text(lastMessage?.message ?? 'Start a conversation'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('HH:mm').format(conversation.updatedAt)),
          if (_unreadCount > 0)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                _unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerChatScreen(
            conversation: conversation,
            currentUserId: currentUserId,
          ),
        ),
      ),
    );
  }

  int get otherUserId => conversation.user1Id == currentUserId
      ? conversation.user2Id
      : conversation.user1Id;

  int get _unreadCount => conversation.messages
      .where((msg) => msg.receiverId == currentUserId && msg.isRead == 0)
      .length;
}
