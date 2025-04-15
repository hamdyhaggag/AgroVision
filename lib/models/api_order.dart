import 'package:json_annotation/json_annotation.dart';

part 'api_order.g.dart';

@JsonSerializable()
class ApiOrder {
  final int id;
  final String subtotal;
  final String vat;
  final String total;
  final String state;
  final String city;
  final String country;
  final String status;
  final String? notes;
  @JsonKey(name: 'is_shipped_different')
  final bool isShippedDifferent;
  @JsonKey(name: 'shipping_address')
  final String? shippingAddress;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ApiOrder({
    required this.id,
    required this.subtotal,
    required this.vat,
    required this.total,
    required this.state,
    required this.city,
    required this.country,
    required this.status,
    this.notes,
    required this.isShippedDifferent,
    this.shippingAddress,
    this.createdAt,
    this.updatedAt,
  });

  factory ApiOrder.fromJson(Map<String, dynamic> json) =>
      _$ApiOrderFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOrderToJson(this);
}
