import 'package:flutter/material.dart';

extension HexColorExtension on String {
  /// Creates a [Color] from a hex string (e.g. "FFFFFF", "#FFFFFF")
  Color toColor() {
    final hexString = replaceAll('#', '');

    if (hexString.length == 6) {
      return Color(int.parse('FF$hexString', radix: 16));
    } else if (hexString.length == 8) {
      return Color(int.parse(hexString, radix: 16));
    }

    throw FormatException('Invalid hex color format: $this');
  }
}

extension ColorsExtension on Colors {
  /// Creates a [Color] from a hex string (e.g. "FFFFFF", "#FFFFFF")
  static Color fromHex(String hexString) {
    return hexString.toColor();
  }
}
