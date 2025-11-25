 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/model/users_response_model.dart';
import 'package:moo_logue/app/modules/home/controllers/bottom_bar_controller.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';

class AppStorage {
  static final _storage = GetStorage();

  // Keys
  static const String _keyIsLogin = 'isLogin';
  
  static const String accessToken = 'accessToken';
  static const String userId = 'userId';
  static const String typeState = 'typeState';
  static const String streakDates = 'streakDates';

  /// Initialize storage
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Save login status
  static Future<void> setLogin(bool value) async {
    await _storage.write(_keyIsLogin, value);
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _storage.read(_keyIsLogin) ?? false;
  }

  static Future<void> setString(String key, String data) async {
    await _storage.write(key, data);
  }

  static String? getString(String key) {
    return _storage.read(key);
  }

  static Future<void> setStringList(String key, List<String> data) async {
    await _storage.write(key, data);
  }

  static List<String> getStringList(String key) {
    final List<dynamic>? raw = _storage.read<List<dynamic>>(key);
    if (raw == null) return <String>[];
    return raw.map((e) => e.toString()).toList();
  }

  /// Logout user
  static Future<void> logout() async {
    await _storage.remove(_keyIsLogin);
    await UserStorageService().clearUser();
    await _storage.erase();
    Get.find<BottomBarController>().currentIndex.value = 0;
    await FirebaseAuth.instance.signOut();
    ctx!.go(Routes.onboarding);
  }
}

class UserStorageService {
  final _box = GetStorage();

  Future<void> saveUser(UserModel user) async {
    await _box.write('userData', user.toJson());
  }

  UserModel? getUser() {
    final data = _box.read<Map<String, dynamic>>('userData');
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<void> clearUser() async {
    await _box.remove('userData');
  }
}
