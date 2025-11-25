import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'text_theme.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.primary),
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    textTheme: buildTextTheme(brightness: Brightness.light),
    cardColor: Colors.white,
  );

  static ThemeData dark() => ThemeData(
    progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.primary),
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: Colors.white,
    ),
    textTheme: buildTextTheme(brightness: Brightness.dark),
    cardColor: Color(0xFF1E1E1E),
  );
}
