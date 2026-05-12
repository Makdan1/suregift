import 'package:json_annotation/json_annotation.dart';

part 'voucher_models.g.dart';

@JsonSerializable()
class VoucherHistoryResponse {
  final int? id;
  final int? orderId;
  final String? productCode;
  final String? productName;
  final String? productImageUrl;
  final double? amount;
  final String? currency;
  final String? voucherCode;
  final String? pin;
  final String? serialNumber;
  final String? expiryDate;
  final String? suregiftsVoucherId;
  final String? suregiftsOrderId;
  final String? createdAtUtc;

  VoucherHistoryResponse({
    this.id,
    this.orderId,
    this.productCode,
    this.productName,
    this.productImageUrl,
    this.amount,
    this.currency,
    this.voucherCode,
    this.pin,
    this.serialNumber,
    this.expiryDate,
    this.suregiftsVoucherId,
    this.suregiftsOrderId,
    this.createdAtUtc,
  });

  factory VoucherHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$VoucherHistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VoucherHistoryResponseToJson(this);
}
