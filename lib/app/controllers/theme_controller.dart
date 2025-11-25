import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moo_logue/app/core/enums/font_size_option.dart';
import 'package:moo_logue/app/core/theme/app_theme.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var fontSizeOption = FontSizeOption.medium.obs;
  final storage = GetStorage();

  ThemeData get lightTheme => AppTheme.light();
  ThemeData get darkTheme => AppTheme.dark();

  @override
  void onInit() {
    super.onInit();
    // Load saved theme mode
    int savedThemeIndex = storage.read('themeIndex') ?? 2; // default to system
    setThemeMode(savedThemeIndex);
  }

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
    storage.write('themeIndex', isDark ? 1 : 0);
  }

  void setThemeMode(int index) {
    // 0 = System, 1 = Light, 2 = Dark
    switch (index) {
      case 0:
        themeMode.value = ThemeMode.system;
        break;
      case 1:
        themeMode.value = ThemeMode.light;
        break;
      case 2:
        themeMode.value = ThemeMode.dark;
        break;
    }
    Get.changeThemeMode(themeMode.value);
    storage.write('themeIndex', index);
  }


  void setFontSize(FontSizeOption option) {
    fontSizeOption.value = option;
    Get.changeThemeMode(themeMode.value);
  }
}
