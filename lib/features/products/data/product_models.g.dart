// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuregiftsProductResponse _$SuregiftsProductResponseFromJson(
        Map<String, dynamic> json) =>
    SuregiftsProductResponse(
      code: json['code'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      currency: json['currency'] as String?,
      minValue: (json['minValue'] as num?)?.toDouble(),
      maxValue: (json['maxValue'] as num?)?.toDouble(),
      denominations: (json['denominations'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      redemptionDetails: (json['redemptionDetails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      stores:
          (json['stores'] as List<dynamic>?)?.map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      validity: json['validity'] == null
          ? null
          : SuregiftsValidityResponse.fromJson(
              json['validity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SuregiftsProductResponseToJson(
        SuregiftsProductResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'currency': instance.currency,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'denominations': instance.denominations,
      'redemptionDetails': instance.redemptionDetails,
      'countries': instance.countries,
      'stores': instance.stores,
      'categories': instance.categories,
      'validity': instance.validity,
    };

SuregiftsValidityResponse _$SuregiftsValidityResponseFromJson(
        Map<String, dynamic> json) =>
    SuregiftsValidityResponse(
      type: json['type'] as String?,
      value: (json['value'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SuregiftsValidityResponseToJson(
        SuregiftsValidityResponse instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
    };
