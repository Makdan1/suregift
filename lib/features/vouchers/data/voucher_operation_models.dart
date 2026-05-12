import 'package:json_annotation/json_annotation.dart';

part 'voucher_operation_models.g.dart';

@JsonSerializable()
class VoucherOperationResponse {
  final String? status;
  final String? message;
  final String? createdAtUtc;

  VoucherOperationResponse({this.status, this.message, this.createdAtUtc});

  factory VoucherOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$VoucherOperationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VoucherOperationResponseToJson(this);
}
