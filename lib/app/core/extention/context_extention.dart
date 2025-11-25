import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Access theme data
  ThemeData get theme => Theme.of(this);

  /// Access color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Access text theme
  TextTheme get textTheme => theme.textTheme;

  /// Access media query size
  Size get screenSize => MediaQuery.of(this).size;
}
