import 'package:rtinnovations_task/core/themes/typography/app_typography.dart';
import 'package:rtinnovations_task/utils/extensions/colors_exs.dart';

import 'app_theme.dart';
import 'package:flutter/material.dart';

class DefaultTheme extends AppThemes {
  @override
  Color get fontColor => Colors.black;

  @override
  String get fontFamily => AppTypography.roboto;

  @override
  Color get primaryColor => ('#1DA1F2').toColor();

  @override
  String get themeName => 'default_theme';

  @override
  Color get whiteColor => ('#FFFFFF').toColor();
}
