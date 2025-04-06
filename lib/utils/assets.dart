/// A utility class that provides access to all app assets.
/// Organized by asset type for better modularity and maintenance.
class AppAssets {
  AppAssets._();

  /// Images used throughout the application
  static const images = _AppImages();

  /// Icons used throughout the application
  static const icons = _AppIcons();

  /// Animations and Lottie files
  static const animations = _AppAnimations();

  /// Fonts used in the application
  static const fonts = _AppFonts();

  /// SVG assets used in the application
  static const svg = _AppSvg();
}

/// Images used throughout the application
class _AppImages {
  const _AppImages();
}

/// Icons used throughout the application
class _AppIcons {
  const _AppIcons();
}

/// Animations and Lottie files
class _AppAnimations {
  const _AppAnimations();
}

/// Fonts used in the application
class _AppFonts {
  /// Private constructor to prevent instantiation
  const _AppFonts();
}

/// SVG assets used in the application
class _AppSvg {
  /// Private constructor to prevent instantiation
  const _AppSvg();
  String get emptyRecords => 'assets/svg/empty_records.svg';
}
