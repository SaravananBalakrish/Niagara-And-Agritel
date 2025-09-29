import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData(RegisterDetailsModel authData);
  Future<RegisterDetailsModel?> getCachedAuthData();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  static const _authDataKey = 'CACHED_AUTH_DATA';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheAuthData(RegisterDetailsModel authData) async {
    await prefs.setString(_authDataKey, jsonEncode(authData.toJson()));
  }

  @override
  Future<RegisterDetailsModel?> getCachedAuthData() async {
    final jsonString = prefs.getString(_authDataKey);
    if (jsonString != null) {
      return RegisterDetailsModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearAuthData() async {
    await prefs.remove(_authDataKey);
  }
}