import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'api_order.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class ApiOrdersResponse {
  final List<ApiOrder> orders;

  ApiOrdersResponse({required this.orders});

  factory ApiOrdersResponse.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('🔍 Parsing API Response: ${json.toString()}');
    }
    return _$ApiOrdersResponseFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ApiOrdersResponseToJson(this);
}
