// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherHistoryResponse _$VoucherHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    VoucherHistoryResponse(
      id: (json['id'] as num?)?.toInt(),
      orderId: (json['orderId'] as num?)?.toInt(),
      productCode: json['productCode'] as String?,
      productName: json['productName'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      voucherCode: json['voucherCode'] as String?,
      pin: json['pin'] as String?,
      serialNumber: json['serialNumber'] as String?,
      expiryDate: json['expiryDate'] as String?,
      suregiftsVoucherId: json['suregiftsVoucherId'] as String?,
      suregiftsOrderId: json['suregiftsOrderId'] as String?,
      createdAtUtc: json['createdAtUtc'] as String?,
    );

Map<String, dynamic> _$VoucherHistoryResponseToJson(
        VoucherHistoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
      'amount': instance.amount,
      'currency': instance.currency,
      'voucherCode': instance.voucherCode,
      'pin': instance.pin,
      'serialNumber': instance.serialNumber,
      'expiryDate': instance.expiryDate,
      'suregiftsVoucherId': instance.suregiftsVoucherId,
      'suregiftsOrderId': instance.suregiftsOrderId,
      'createdAtUtc': instance.createdAtUtc,
    };
