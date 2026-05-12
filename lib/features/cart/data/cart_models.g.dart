// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponse _$CartResponseFromJson(Map<String, dynamic> json) => CartResponse(
      cartId: (json['cartId'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$CartResponseToJson(CartResponse instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'currency': instance.currency,
    };

CartItemResponse _$CartItemResponseFromJson(Map<String, dynamic> json) =>
    CartItemResponse(
      id: (json['id'] as num?)?.toInt(),
      productCode: json['productCode'] as String?,
      productName: json['productName'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CartItemResponseToJson(CartItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
      'unitPrice': instance.unitPrice,
      'currency': instance.currency,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
    };

CartTotalResponse _$CartTotalResponseFromJson(Map<String, dynamic> json) =>
    CartTotalResponse(
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      fees: (json['fees'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$CartTotalResponseToJson(CartTotalResponse instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'fees': instance.fees,
      'total': instance.total,
      'currency': instance.currency,
    };
