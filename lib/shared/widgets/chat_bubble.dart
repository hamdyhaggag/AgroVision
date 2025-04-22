import 'dart:io';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/chat_message.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final VoidCallback onLongPress;
  final bool isLoading;
  final Color? loadingColor;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onLongPress,
    this.isLoading = false,
    this.loadingColor,
  });

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
        _dotAnimations.clear();
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
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.message.imageUrl != null)
                    _buildImagePreview(widget.message.imageUrl!),
                  if (widget.message.voiceFilePath != null && !widget.isLoading)
                    _buildVoiceMessage(widget.message.voiceFilePath!),
                  if (widget.isLoading && !widget.message.isSentByMe)
                    _buildTypingIndicator(),
                  if (widget.message.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final isArabicText = isArabic(widget.message.text);
                        return Directionality(
                          textDirection: isArabicText
                              ? ui.TextDirection.rtl
                              : ui.TextDirection.ltr,
                          child: MarkdownBody(
                            data: widget.message.text,
                            styleSheet: MarkdownStyleSheet(
                              h2: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: isArabicText ? 'DIN' : 'SYNE',
                              ),
                              p: TextStyle(
                                fontSize: 15,
                                fontFamily: isArabicText ? 'DIN' : 'SYNE',
                              ),
                              listBullet: TextStyle(
                                fontSize: 15,
                                fontFamily: isArabicText ? 'DIN' : 'SYNE',
                              ),
                              listIndent: 24.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
    final isNetworkImage = url.startsWith('http');

    Widget imageWidget;
    if (isNetworkImage) {
      imageWidget = CachedNetworkImage(
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
      );
    } else {
      imageWidget = Image.file(
        File(url),
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, stack) => const Icon(Icons.broken_image),
      );
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                child: isNetworkImage
                    ? CachedNetworkImage(imageUrl: url)
                    : Image.file(File(url)),
              ),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      ),
    );
  }

  Widget _buildVoiceMessage(String filePath) {
    return VoiceMessageBubble(filePath: filePath);
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
}

class VoiceMessageBubble extends StatefulWidget {
  final String filePath;
  const VoiceMessageBubble({super.key, required this.filePath});

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late final PlayerController _playerController;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() => isPlaying = false);
      _playerController = PlayerController();
      _preparePlayer();
    });
  }

  Future<void> _preparePlayer() async {
    try {
      await _playerController.preparePlayer(path: widget.filePath);
    } catch (e) {
      debugPrint('Error preparing audio: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.filePath));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          Expanded(
            child: AudioFileWaveforms(
              playerController: _playerController,
              size: const Size(double.infinity, 50),
              waveformType: WaveformType.fitWidth,
              enableSeekGesture: true,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
