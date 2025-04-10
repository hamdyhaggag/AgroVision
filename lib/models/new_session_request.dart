class NewSessionRequest {
  final String userId;

  NewSessionRequest(this.userId);

  Map<String, dynamic> toJson() => {'user_id': userId};
}
