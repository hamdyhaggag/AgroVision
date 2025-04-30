class ChatRequestBody {
  final String query;
  final String userId;
  final String sessionId;

  ChatRequestBody({
    required this.query,
    required this.userId,
    required this.sessionId,
  });
  Map<String, dynamic> toJson() => {
        'query': query,
        'user_id': userId,
        'session_id': sessionId,
      };
}

class ChatResponse {
  final String answer;

  ChatResponse({required this.answer});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      answer: json['answer'] ?? json['Answer'] ?? json['text'] ?? '',
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final String? imageUrl;
  final String? audioUrl;
  final String? voiceFilePath;
  final MessageStatus status;
  final String? sessionId;

  Message({
    required this.text,
    required this.isSentByMe,
    this.sessionId,
    DateTime? timestamp,
    this.imageUrl,
    this.status = MessageStatus.delivered,
    this.audioUrl,
    this.voiceFilePath,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'text': text,
        'isSentByMe': isSentByMe,
        'timestamp': timestamp.toIso8601String(),
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'voiceFilePath': voiceFilePath,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        text: json['text'],
        isSentByMe: json['isSentByMe'],
        timestamp: DateTime.parse(json['timestamp']),
        imageUrl: json['imageUrl'],
        audioUrl: json['audioUrl'],
        voiceFilePath: json['voiceFilePath'],
      );
}

enum MessageStatus { pending, delivered, error }
