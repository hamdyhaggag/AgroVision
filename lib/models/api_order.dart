import 'package:json_annotation/json_annotation.dart';

part 'api_order.g.dart';

@JsonSerializable()
class ApiOrder {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String subtotal;
  final String discount;
  final String total;
  final String name;
  final String phone;
  final String city;
  final String country;
  final String status;
  @JsonKey(name: 'is_shipping_different')
  final bool isShippingDifferent;
  @JsonKey(name: 'delivered_date', nullable: true)
  final DateTime? deliveredDate;
  @JsonKey(name: 'canceled_date', nullable: true)
  final DateTime? canceledDate;
  @JsonKey(name: 'created_at', nullable: true)
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  final DateTime? updatedAt;

  ApiOrder({
    required this.id,
    required this.userId,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.name,
    required this.phone,
    required this.city,
    required this.country,
    required this.status,
    required this.isShippingDifferent,
    this.deliveredDate,
    this.canceledDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ApiOrder.fromJson(Map<String, dynamic> json) =>
      _$ApiOrderFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOrderToJson(this);
}
