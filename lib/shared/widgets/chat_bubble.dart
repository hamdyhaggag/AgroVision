import 'dart:io';
import 'dart:ui' as ui;
import 'package:audio_waveforms/audio_waveforms.dart' as aw;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/helpers/cache_helper.dart';
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
                    AudioUrlBubble(
                      audioUrl: widget.message.audioUrl!.startsWith('http')
                          ? widget.message.audioUrl!
                          : 'https://immortal-basically-lemur.ngrok-free.app${widget.message.audioUrl!}',
                      key: ValueKey(widget.message.audioUrl),
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

class AudioUrlBubble extends StatefulWidget {
  final String audioUrl;

  const AudioUrlBubble({
    super.key,
    required this.audioUrl,
  });

  @override
  State<AudioUrlBubble> createState() => _AudioUrlBubbleState();
}

class _AudioUrlBubbleState extends State<AudioUrlBubble>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _localAudioPath;
  bool _isLoadingAudio = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _setupAudioPlayer();
    _loadLocalAudio();
  }

  Future<void> _loadLocalAudio() async {
    setState(() {
      _isLoadingAudio = true;
    });
    // Check if the audio path is already cached
    final cachedPath = CacheHelper.getAudioFilePath(widget.audioUrl);
    if (cachedPath.isNotEmpty && await File(cachedPath).exists()) {
      setState(() {
        _localAudioPath = cachedPath;
        _isLoadingAudio = false;
      });
    } else {
      try {
        final localPath = await _downloadAudio(widget.audioUrl);
        await CacheHelper.saveAudioFilePath(widget.audioUrl, localPath);
        setState(() {
          _localAudioPath = localPath;
          _isLoadingAudio = false;
        });
      } catch (e) {
        print('Error downloading audio: $e');
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
  }

  Future<String> _downloadAudio(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    final filePath = '${dir.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download audio');
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _playerState = state);
      if (state == PlayerState.playing) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.reset();
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });
  }

  Future<void> _togglePlayPause() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      if (_localAudioPath != null) {
        await _audioPlayer.play(DeviceFileSource(_localAudioPath!));
      } else {
        await _audioPlayer.play(UrlSource(widget.audioUrl));
      }
    }
  }

  String _formatDuration(Duration d) =>
      '${(d.inMinutes).toString().padLeft(2, '0')}:'
      '${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  Future<void> _shareAudio() async {
    try {
      await Share.share(widget.audioUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;
    final progress = _duration.inSeconds > 0
        ? _position.inSeconds / _duration.inSeconds
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _isLoadingAudio
                    ? const CircularProgressIndicator()
                    : AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) => Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 28,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: _togglePlayPause,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Khedr’s voice',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 20),
                  color: Colors.grey[600],
                  onPressed: _shareAudio,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: Theme.of(context).primaryColor,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
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

class _VoiceMessageBubbleState extends State<VoiceMessageBubble>
    with SingleTickerProviderStateMixin {
  late final aw.PlayerController _playerController;
  Duration? _duration;
  Duration _currentDuration = Duration.zero;
  aw.PlayerState? _playerState;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _playerController = aw.PlayerController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _preparePlayer();
    _setupListeners();
  }

  Future<void> _preparePlayer() async {
    try {
      await _playerController.preparePlayer(path: widget.filePath);
      final durationMs = await _playerController.getDuration();
      setState(() {
        _duration = Duration(milliseconds: durationMs);
      });
    } catch (e) {
      debugPrint('Error preparing audio: $e');
    }
  }

  void _setupListeners() {
    _playerController.onPlayerStateChanged.listen((state) {
      if (kDebugMode) {
        print('Player state changed to: $state');
      }
      setState(() {
        _playerState = state;
        if (state == aw.PlayerState.playing) {
          _animationController.repeat(reverse: true);
        } else {
          _animationController.reset();
        }
        if (state == aw.PlayerState.stopped && _currentDuration >= _duration!) {
          _currentDuration = Duration.zero;
          if (kDebugMode) {
            print('Stopped and reset duration to zero');
          }
        }
      });
    });

    _playerController.onCompletion.listen((_) {
      if (kDebugMode) {
        print('Audio completed');
      }
      setState(() {
        _currentDuration = Duration.zero;
      });
      _playerController.seekTo(0);
      if (kDebugMode) {
        print('Seeked to 0 after completion');
      }
    });

    _playerController.onCurrentDurationChanged.listen((durationMs) {
      if (kDebugMode) {
        print('Current duration updated: $durationMs ms');
      }
      setState(() => _currentDuration = Duration(milliseconds: durationMs));
    });
  }

  Future<void> _togglePlayPause() async {
    if (kDebugMode) {
      print('Toggle play/pause. Player state: $_playerState, '
          'Current duration: $_currentDuration, Total duration: $_duration');
    }
    if (_playerState == aw.PlayerState.playing) {
      await _playerController.pausePlayer();
      if (kDebugMode) {
        print('Paused audio');
      }
    } else {
      if (_playerState == aw.PlayerState.stopped ||
          _currentDuration >= _duration!) {
        if (kDebugMode) {
          print('Preparing player again');
        }
        await _playerController.stopPlayer();
        await _playerController.preparePlayer(path: widget.filePath);
        await _playerController.seekTo(0);
      }
      try {
        await _playerController.startPlayer();
        if (kDebugMode) {
          print('Started playing');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error starting player: $e');
        }
      }
    }
  }

  String _formatDuration(Duration duration) =>
      '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
      '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _playerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == aw.PlayerState.playing;
    final progress = _duration != null && _duration!.inMilliseconds > 0
        ? _currentDuration.inMilliseconds / _duration!.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: _togglePlayPause,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Message',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDuration(_currentDuration)} / '
                      '${_formatDuration(_duration ?? Duration.zero)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.share_rounded, size: 20),
                color: Colors.grey[600],
                onPressed: () => _shareAudio(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Theme.of(context).primaryColor,
              minHeight: 2,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _shareAudio() async {
    try {
      await Share.shareXFiles(
        [XFile(widget.filePath)],
        text: 'Voice message from AgroVision',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing: ${e.toString()}')),
      );
    }
  }
}
