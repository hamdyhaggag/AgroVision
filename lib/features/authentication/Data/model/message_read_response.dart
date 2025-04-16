import 'package:json_annotation/json_annotation.dart';

part 'message_read_response.g.dart';

@JsonSerializable()
class MessageReadResponse {
  final String message;

  MessageReadResponse({required this.message});

  factory MessageReadResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageReadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MessageReadResponseToJson(this);
}
