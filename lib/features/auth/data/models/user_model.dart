import '../../domain/entities/user.dart';
import 'dart:convert';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.mobile,
  });

  /// Convert JSON from API into UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  /// Optional: create from JSON string
  factory UserModel.fromJsonString(String jsonString) {
    final Map<String, dynamic> map = json.decode(jsonString);
    return UserModel.fromJson(map);
  }

  /// Convert UserModel to JSON for storage or API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
    };
  }

  /// Optional: to JSON string
  String toJsonString() => json.encode(toJson());

  /// Convert to domain entity (already extends User, so this is trivial)
  User toEntity() => this;
}
