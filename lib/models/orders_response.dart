import 'package:json_annotation/json_annotation.dart';
import 'api_order.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class ApiOrdersResponse {
  final bool success;
  final List<ApiOrder> data;

  ApiOrdersResponse({required this.success, required this.data});

  factory ApiOrdersResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing API Response: ${json.toString()}'); // Add this line
    return _$ApiOrdersResponseFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ApiOrdersResponseToJson(this);
}
