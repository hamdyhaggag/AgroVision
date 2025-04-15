// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiOrdersResponse _$ApiOrdersResponseFromJson(Map<String, dynamic> json) =>
    ApiOrdersResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ApiOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiOrdersResponseToJson(ApiOrdersResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
