// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiOrdersResponse _$ApiOrdersResponseFromJson(Map<String, dynamic> json) =>
    ApiOrdersResponse(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => ApiOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiOrdersResponseToJson(ApiOrdersResponse instance) =>
    <String, dynamic>{
      'orders': instance.orders,
    };
