// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAccountResponse _$UpdateAccountResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateAccountResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateAccountResponseToJson(
        UpdateAccountResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      birthday: json['birthday'] as String?,
      img: json['img'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'birthday': instance.birthday,
      'img': instance.img,
    };
