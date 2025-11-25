import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DisplayViewController extends GetxController {
  final storage = GetStorage();

  // Font size
  RxInt selectedFontIndex = 1.obs; // Default Medium
  RxString selectedFontName = ''.obs;

  // Theme
  RxInt selectedThemeIndex = 0.obs; // Default System
  RxString selectedThemeName = ''.obs;

  RxList<Map<String, dynamic>> displayList = <Map<String, dynamic>>[
    {'DisplayIcon': AppAssets.fontSizeIcon, 'DisplayName': AppString.fontSize, 'DisplayDisc': AppString.medium},
    {'DisplayIcon': AppAssets.colorBlindModeIcon, 'DisplayName': AppString.colorBlindMode, 'DisplayDisc': AppString.enabled},
  ].obs;

  RxList<String> fontSizeList = [AppString.small, AppString.medium, AppString.large].obs;

  RxList<String> themeList = [AppString.systemMode, AppString.lightMode, AppString.darkMode].obs;

  @override
  void onInit() {
    super.onInit();

    // Load saved font size
    selectedFontIndex.value = storage.read('fontIndex') ?? 1;
    selectedFontName.value = fontSizeList[selectedFontIndex.value];

    // Load saved theme
    selectedThemeIndex.value = storage.read('themeIndex') ?? 0;
    selectedThemeName.value = themeList[selectedThemeIndex.value];
  }

  void changeFontSize(int index) {
    selectedFontIndex.value = index;
    selectedFontName.value = fontSizeList[index];
    storage.write('fontIndex', index); // Save to storage
  }

  void changeTheme(int index) {
    selectedThemeIndex.value = index;
    selectedThemeName.value = themeList[index];
    storage.write('themeIndex', index); // Save to storage
  }
}
