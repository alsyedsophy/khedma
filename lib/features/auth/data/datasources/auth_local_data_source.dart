import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:khedma/Core/constants/app_emums.dart';
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
  // Future<void> setUserType(UserType userType);
  // Future<void> setLocationSelecte();
  // Future<void> setProfileCompleted();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  static const _userKey = 'CACHED_USER';
  static const _firstTimeKey = 'IS_FIRST_TIME';
  // static const _userType = 'USER_TYPE';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(_userKey);
      log('getCachedUser: jsonString = $jsonString');
      if (jsonString == null) return null;
      try {
        return UserModel.fromJson(json.decode(jsonString));
      } catch (e) {
        await sharedPreferences.remove(_userKey);
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      log('cacheUser called with user: ${user.id}');
      final jsonString = json.encode(user.toJson());
      log('JSON to store: $jsonString');
      await sharedPreferences.setString(_userKey, jsonString);
      log('Cached user in local successfully');
    } catch (e, stack) {
      log('Error caching user: $e\n$stack');
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

  // @override
  // Future<void> setUserType(UserType userType) async {
  //   await sharedPreferences.setString(_userType, userType.toString());
  // }

  // @override
  // Future<void> setLocationSelecte() async{
  //   await sharedPreferences.setBool('isLocationSelected', true);
  // }

  // @override
  // Future<void> setProfileCompleted() async{
  //   await sharedPreferences.setBool('isProfileCompleted', true);
  // }
}
