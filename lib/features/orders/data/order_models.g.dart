// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      id: (json['id'] as num?)?.toInt(),
      orderNumber: json['orderNumber'] as String?,
      status: json['status'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      voucherCount: (json['voucherCount'] as num?)?.toInt(),
      createdAtUtc: json['createdAtUtc'] as String?,
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'voucherCount': instance.voucherCount,
      'createdAtUtc': instance.createdAtUtc,
    };
