import 'package:json_annotation/json_annotation.dart';

part 'cart_models.g.dart';

@JsonSerializable()
class CartResponse {
  final int? cartId;
  final List<CartItemResponse>? items;
  final double? subtotal;
  final String? currency;

  CartResponse({this.cartId, this.items, this.subtotal, this.currency});

  factory CartResponse.fromJson(Map<String, dynamic> json) => _$CartResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

@JsonSerializable()
class CartItemResponse {
  final int? id;
  final String? productCode;
  final String? productName;
  final String? productImageUrl;
  final double? unitPrice;
  final String? currency;
  final int? quantity;
  final double? subtotal;

  CartItemResponse({
    this.id,
    this.productCode,
    this.productName,
    this.productImageUrl,
    this.unitPrice,
    this.currency,
    this.quantity,
    this.subtotal,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) => _$CartItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemResponseToJson(this);
}

@JsonSerializable()
class CartTotalResponse {
  final double? subtotal;
  final double? fees;
  final double? total;
  final String? currency;

  CartTotalResponse({this.subtotal, this.fees, this.total, this.currency});

  factory CartTotalResponse.fromJson(Map<String, dynamic> json) => _$CartTotalResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CartTotalResponseToJson(this);
}
