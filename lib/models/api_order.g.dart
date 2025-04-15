// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiOrder _$ApiOrderFromJson(Map<String, dynamic> json) => ApiOrder(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      subtotal: json['subtotal'] as String,
      discount: json['discount'] as String,
      total: json['total'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      status: json['status'] as String,
      isShippingDifferent: json['is_shipping_different'] as bool,
      deliveredDate: json['delivered_date'] == null
          ? null
          : DateTime.parse(json['delivered_date'] as String),
      canceledDate: json['canceled_date'] == null
          ? null
          : DateTime.parse(json['canceled_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApiOrderToJson(ApiOrder instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total': instance.total,
      'name': instance.name,
      'phone': instance.phone,
      'city': instance.city,
      'country': instance.country,
      'status': instance.status,
      'is_shipping_different': instance.isShippingDifferent,
      'delivered_date': instance.deliveredDate?.toIso8601String(),
      'canceled_date': instance.canceledDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
