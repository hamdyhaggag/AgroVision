import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<Message> messages = [
    Message(
        text: 'The wheat leaves have unusual spots, could it be a disease?',
        isSentByMe: false),
    Message(text: 'Let me check the crop monitoring app.', isSentByMe: true),
    Message(text: 'Great idea! Let me know what you find.', isSentByMe: false),
  ];

  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageSend(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add(Message(text: text, isSentByMe: true));
    });
    _messageController.clear();
  }

  void _onMessageLongPress(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              setState(() {
                messages.remove(message);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _onMessageSwipe(Message message) {
    // Implement your reply logic here, e.g., highlight the message or pre-fill the reply input
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Replying to: "${message.text}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final title = arguments != null ? arguments['title'] as String : 'Chat';

    return Scaffold(
      appBar: _buildAppBar(title),
      body: Column(
        children: [
          _buildChatMessages(),
          const Divider(height: 1),
          _buildInputBar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Dismissible(
            key: Key(message.text),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _onMessageSwipe(message),
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.blue.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.reply, color: Colors.blue),
            ),
            child: GestureDetector(
              onLongPress: () => _onMessageLongPress(message),
              child: Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isSentByMe
                        ? Colors.green.shade100
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle, color: Colors.green),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: _onMessageSend,
            ),
          ),
          IconButton(
            onPressed: () => _onMessageSend(_messageController.text),
            icon: const Icon(Icons.send, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;

  Message({required this.text, required this.isSentByMe});
}
