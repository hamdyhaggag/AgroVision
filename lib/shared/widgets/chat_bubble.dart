import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../models/chat_message.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final VoidCallback onLongPress;
  final bool isLoading;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onLongPress,
    this.isLoading = false,
    this.loadingColor,
  });
  final Color? loadingColor;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) {
      _initializeAnimations();
    }
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
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _initializeAnimations();
      } else {
        _controller.dispose();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.isLoading) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: widget.message.isSentByMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.message.isSentByMe
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: widget.isLoading
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.message.imageUrl != null && !widget.isLoading)
                    _buildImagePreview(widget.message.imageUrl!),
                  if (widget.isLoading) _buildTypingIndicator(),
                  if (!widget.isLoading) ...[
                    Text(
                      widget.message.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'SYNE',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(widget.message.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontFamily: 'SYNE',
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              color: widget.loadingColor ??
                  (widget.message.isSentByMe
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600]),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImagePreview(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          width: 200,
          height: 150,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
