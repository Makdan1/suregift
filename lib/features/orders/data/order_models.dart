import 'package:json_annotation/json_annotation.dart';

part 'order_models.g.dart';

@JsonSerializable()
class OrderResponse {
  final int? id;
  final String? orderNumber;
  final String? status;
  final double? totalAmount;
  final String? currency;
  final int? voucherCount;
  final String? createdAtUtc;

  OrderResponse({
    this.id,
    this.orderNumber,
    this.status,
    this.totalAmount,
    this.currency,
    this.voucherCount,
    this.createdAtUtc,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}
