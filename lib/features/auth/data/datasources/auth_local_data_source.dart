import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khedma/Core/errors/extentions.dart';
import 'package:khedma/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// مصدر البيانات المحلية للمصادقة
abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser(); // الحصول على المستخدم المخزن
  Future<void> cacheUser(UserModel user); // تخزين المستخدم
  Future<void> clearUser(); // مسح بيانات المستخدم
  Future<bool> isFirstTime(); // التحقق من أول مرة
  Future<void> setFirstTimeDone(); // تعيين أول مرة كمستخدم
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  static const _userKey = 'CACHED_USER';
  static const _firstTimeKey = 'IS_FIRST_TIME';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = await secureStorage.read(key: _userKey);
      if (jsonString == null) return null;
      return UserModel.fromJson(json.decode(jsonString));
    } catch (_) {
      throw const CacheException('Failed to get cached user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await secureStorage.write(
        key: _userKey,
        value: json.encode(user.toJson()), // نحتاج إضافة toJson
      );
    } catch (_) {
      throw const CacheException('Failed to cache user');
    }
  }

  @override
  Future<void> clearUser() async {
    await secureStorage.delete(key: _userKey);
  }

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool(_firstTimeKey) ?? true;
  }

  @override
  Future<void> setFirstTimeDone() async {
    await sharedPreferences.setBool(_firstTimeKey, false);
  }
}
