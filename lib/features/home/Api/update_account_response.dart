import 'package:json_annotation/json_annotation.dart';

part 'update_account_response.g.dart';

@JsonSerializable()
class UpdateAccountResponse {
  final String message;
  final User user;

  UpdateAccountResponse({required this.message, required this.user});

  factory UpdateAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateAccountResponseFromJson(json);
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? birthday;
  final String? img;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthday,
    this.img,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
