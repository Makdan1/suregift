import 'package:json_annotation/json_annotation.dart';
import '../../vouchers/data/voucher_models.dart';

part 'checkout_models.g.dart';

@JsonSerializable()
class CheckoutResponse {
  final int? orderId;
  final String? paymentReference;
  final String? status;
  final double? totalAmount;
  final String? currency;
  final String? suregiftsOrderId;
  final String? failureReason;
  final List<VoucherHistoryResponse>? vouchers;

  CheckoutResponse({
    this.orderId,
    this.paymentReference,
    this.status,
    this.totalAmount,
    this.currency,
    this.suregiftsOrderId,
    this.failureReason,
    this.vouchers,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) => _$CheckoutResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CheckoutResponseToJson(this);
}
