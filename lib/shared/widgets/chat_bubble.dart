import 'dart:io';
import 'dart:ui' as ui;
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:audio_waveforms/audio_waveforms.dart' as aw;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shimmer/shimmer.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/chat_message.dart';
import 'package:share_plus/share_plus.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    if (widget.message.voiceFilePath != oldWidget.message.voiceFilePath) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (widget.isLoading) _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.message.imageUrl != null)
                    _buildImagePreview(widget.message.imageUrl!),
                  if (widget.message.voiceFilePath != null)
                    VoiceMessageBubble(
                      key: ValueKey(widget.message.voiceFilePath),
                      filePath: widget.message.voiceFilePath!,
                    ),
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
                  if (widget.message.audioUrl != null)
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => _playAudio(widget.message.audioUrl!),
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
    return GestureDetector(
      onTap: () => showDialog(
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isNetworkImage
            ? CachedNetworkImage(
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
              )
            : Image.file(
                File(url),
                width: 200,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) =>
                    const Icon(Icons.broken_image),
              ),
      ),
    );
  }

  bool isArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}

class VoiceMessageBubble extends StatefulWidget {
  final String filePath;

  const VoiceMessageBubble({
    super.key,
    required this.filePath,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late final aw.PlayerController _playerController;
  Duration? _duration;
  Duration _currentDuration = Duration.zero;
  aw.PlayerState? _playerState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _playerController = aw.PlayerController();
    _preparePlayer();
    _setupListeners();
  }

  Future<void> _preparePlayer() async {
    try {
      await _playerController.preparePlayer(path: widget.filePath);
      final durationMs = await _playerController.getDuration();
      setState(() {
        _duration = Duration(milliseconds: durationMs);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error preparing audio: $e');
    }
  }

  void _setupListeners() {
    _playerController.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
        if (state == aw.PlayerState.stopped) _currentDuration = Duration.zero;
      });
    });
    _playerController.onCurrentDurationChanged.listen((durationMs) {
      setState(() => _currentDuration = Duration(milliseconds: durationMs));
    });
  }

  Future<void> _togglePlayPause() async {
    _playerState == aw.PlayerState.playing
        ? await _playerController.pausePlayer()
        : await _playerController.startPlayer();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) =>
      '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
      '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_playerState == aw.PlayerState.playing
                ? Icons.pause
                : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          Expanded(
            child: aw.AudioFileWaveforms(
              playerController: _playerController,
              size: const Size(double.infinity, 50),
              waveformType: aw.WaveformType.fitWidth,
              enableSeekGesture: true,
              playerWaveStyle: const aw.PlayerWaveStyle(
                fixedWaveColor: AppColors.primaryColor,
                liveWaveColor: Colors.grey,
                spacing: 6,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_duration != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _playerState == aw.PlayerState.playing
                        ? _formatDuration(_currentDuration)
                        : _formatDuration(_duration!),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.blackColor),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                color: AppColors.primaryColor,
                onPressed: () async {
                  try {
                    await Share.shareXFiles(
                      [XFile(widget.filePath)],
                      text: 'Shared voice message from AgroVision',
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error sharing file: ${e.toString()}')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
