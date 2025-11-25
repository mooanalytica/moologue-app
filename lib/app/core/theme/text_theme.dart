import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';

class FontFamily {
  static const String ivyPresto = 'IvyPresto';
  static const String poppins = 'Poppins';
}

TextTheme buildTextTheme({required Brightness brightness}) {
  final color = brightness == Brightness.dark
      ? Colors.white
      : AppColors.primaryTextColor;

  return TextTheme(
    // IvyPresto for headings
    displayLarge: TextStyle(
      fontFamily: 'IvyPresto',
      fontSize: 35.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    displayMedium: TextStyle(
      fontFamily: 'IvyPresto',
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    displaySmall: TextStyle(
      fontFamily: 'IvyPresto',
      fontSize: 22.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'IvyPresto',
      fontSize: 20.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'IvyPresto',
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'IvyPresto',
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),

    // Poppins for body
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: color,
    ),
  );
}
