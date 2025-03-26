class ChatRequestBody {
  final String text;

  ChatRequestBody({required this.text});

  Map<String, dynamic> toJson() => {'text': text};
}

class ChatResponse {
  final String response;

  ChatResponse({required this.response});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(response: json['response'] ?? '');
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
