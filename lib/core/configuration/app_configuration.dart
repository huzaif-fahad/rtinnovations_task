import 'package:google_fonts/google_fonts.dart';

import '/router/app_router.dart';
import '../l10n/models/app_localization.dart' show Language, AppLocalization;
import '../themes/app_theme.dart';
import '../themes/theme_handler.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

/// [AppConfiguration] will have an hold on all kinds of configurations for the app
/// which will include theme, language, the environment of the app
class AppConfiguration extends ChangeNotifier {
  static final AppConfiguration i = AppConfiguration._i();

  factory AppConfiguration() => i;

  AppConfiguration._i();

  String currentThemeName = '';
  String currentLanguageCode = '';

  Future<void> initializeApp() async {
    // initialize theme
    await ThemeHandler().initializeTheme();

    // initialize go router
    AppRouter().init();

    GoogleFonts.config.allowRuntimeFetching = true;
  }

  void changeTheme(AppThemes theme) {
    ThemeHandler.i.updateTheme(theme);

    currentThemeName = theme.themeName;

    notifyListeners();
  }

  void changeLanguage(Language language) {
    AppLocalization.updateLanguage(language);

    currentLanguageCode = language.getCode();

    notifyListeners();
  }
}
