// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutResponse _$CheckoutResponseFromJson(Map<String, dynamic> json) =>
    CheckoutResponse(
      orderId: (json['orderId'] as num?)?.toInt(),
      paymentReference: json['paymentReference'] as String?,
      status: json['status'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      suregiftsOrderId: json['suregiftsOrderId'] as String?,
      failureReason: json['failureReason'] as String?,
      vouchers: (json['vouchers'] as List<dynamic>?)
          ?.map(
              (e) => VoucherHistoryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckoutResponseToJson(CheckoutResponse instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'paymentReference': instance.paymentReference,
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'suregiftsOrderId': instance.suregiftsOrderId,
      'failureReason': instance.failureReason,
      'vouchers': instance.vouchers,
    };
