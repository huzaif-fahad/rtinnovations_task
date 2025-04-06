import 'package:flutter/material.dart' show Color;

/// Abstract class [AppThemes] serves as a blueprint for defining theme-specific properties
/// within the application. It ensures that all themes implement a consistent set of properties,
abstract class AppThemes {
  String get themeName;

  String get fontFamily;

  Color get primaryColor;

  Color get fontColor;
}
