import 'package:json_annotation/json_annotation.dart';

part 'product_models.g.dart';

@JsonSerializable()
class SuregiftsProductResponse {
  final String? code;
  final String? name;
  final String? imageUrl;
  final String? description;
  final String? currency;
  final double? minValue;
  final double? maxValue;
  final List<double>? denominations;
  final List<String>? redemptionDetails;
  final List<String>? countries;
  final List<String>? stores;
  final List<String>? categories;
  final SuregiftsValidityResponse? validity;

  SuregiftsProductResponse({
    this.code,
    this.name,
    this.imageUrl,
    this.description,
    this.currency,
    this.minValue,
    this.maxValue,
    this.denominations,
    this.redemptionDetails,
    this.countries,
    this.stores,
    this.categories,
    this.validity,
  });

  /// Business Logic: Returns a filtered, unique, and sorted list of valid amounts (>= 1.0)
  List<double> get validAmounts {
    final List<double> raw = denominations ?? [];
    if (raw.isEmpty) {
      if (minValue != null) raw.add(minValue!);
      if (maxValue != null) raw.add(maxValue!);
    }
    final sorted = raw.toSet().where((a) => a >= 1.0).toList();
    sorted.sort();
    return sorted;
  }

  factory SuregiftsProductResponse.fromJson(Map<String, dynamic> json) =>
      _$SuregiftsProductResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SuregiftsProductResponseToJson(this);
}

@JsonSerializable()
class SuregiftsValidityResponse {
  final String? type;
  final int? value;

  SuregiftsValidityResponse({this.type, this.value});

  factory SuregiftsValidityResponse.fromJson(Map<String, dynamic> json) =>
      _$SuregiftsValidityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SuregiftsValidityResponseToJson(this);
}
