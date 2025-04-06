import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme_handler.dart';

class AppTypography {
  static final AppTypography _instance = AppTypography._internal();
  factory AppTypography() {
    return _instance;
  }
  AppTypography._internal();

  static const double fontSize24 = 24;
  static const double fontSize20 = 20;
  static const double fontSize18 = 18;
  static const double fontSize16 = 16;
  static const double fontSize14 = 14;
  static const double fontSize12 = 12;
  static const double fontSize10 = 10;
  static const double fontSize8 = 8;
  static const double fontSize6 = 6;

  static TextStyle h5 = GoogleFonts.roboto(
    fontSize: fontSize18,
    color: ThemeHandler.currentTheme.whiteColor,
    fontWeight: FontWeight.w500,
  );
}
