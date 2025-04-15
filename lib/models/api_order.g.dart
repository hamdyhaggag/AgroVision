// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiOrder _$ApiOrderFromJson(Map<String, dynamic> json) => ApiOrder(
      id: (json['id'] as num).toInt(),
      subtotal: json['subtotal'] as String,
      vat: json['vat'] as String,
      total: json['total'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      isShippedDifferent: json['is_shipped_different'] as bool,
      shippingAddress: json['shipping_address'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ApiOrderToJson(ApiOrder instance) => <String, dynamic>{
      'id': instance.id,
      'subtotal': instance.subtotal,
      'vat': instance.vat,
      'total': instance.total,
      'state': instance.state,
      'city': instance.city,
      'country': instance.country,
      'status': instance.status,
      'notes': instance.notes,
      'is_shipped_different': instance.isShippedDifferent,
      'shipping_address': instance.shippingAddress,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
