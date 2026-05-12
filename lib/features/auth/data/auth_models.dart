import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginResponse {
  final String? accessToken;
  final String? expiresAtUtc;
  final UserResponse? user;

  LoginResponse({this.accessToken, this.expiresAtUtc, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UserResponse {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;

  UserResponse({this.id, this.email, this.firstName, this.lastName});

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class ErrorResponse {
  final String? error;
  final String? message;

  ErrorResponse({this.error, this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
