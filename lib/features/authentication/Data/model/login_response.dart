import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String message;
  final String token;
  final String role;
  final int id;
  @JsonKey(name: 'name')
  final String name;
  final String email;

  LoginResponse({
    required this.message,
    required this.token,
    required this.role,
    required this.id,
    required this.name,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
