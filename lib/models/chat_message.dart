class ChatRequestBody {
  final String query;

  ChatRequestBody({required this.query});

  Map<String, dynamic> toJson() => {'query': query};
}

class ChatResponse {
  final String answer;

  ChatResponse({required this.answer});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      answer: json['Answer'] ?? 'No response available',
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final String? imageUrl;
  final String? audioUrl;

  Message({
    required this.text,
    required this.isSentByMe,
    DateTime? timestamp,
    this.imageUrl,
    this.audioUrl,
  }) : timestamp = timestamp ?? DateTime.now();
}
