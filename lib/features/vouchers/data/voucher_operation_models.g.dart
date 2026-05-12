// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_operation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherOperationResponse _$VoucherOperationResponseFromJson(
        Map<String, dynamic> json) =>
    VoucherOperationResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      createdAtUtc: json['createdAtUtc'] as String?,
    );

Map<String, dynamic> _$VoucherOperationResponseToJson(
        VoucherOperationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'createdAtUtc': instance.createdAtUtc,
    };
