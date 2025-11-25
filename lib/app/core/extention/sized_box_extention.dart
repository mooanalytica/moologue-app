import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumPaddingExtensions on num {
  /// Horizontal SizedBox
  SizedBox get heightBox => SizedBox(height: toDouble().h);

  /// Vertical SizedBox
  SizedBox get widthBox => SizedBox(width: toDouble().w);

  /// Padding on all sides
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Symmetric padding horizontal
  EdgeInsets get hPadding => EdgeInsets.symmetric(horizontal: toDouble().h);

  /// Symmetric padding vertical
  EdgeInsets get vPadding => EdgeInsets.symmetric(vertical: toDouble().w);
}
