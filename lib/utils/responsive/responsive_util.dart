import 'package:flutter/material.dart';

class ResponsiveUtil {
  static const Size _defaultSize =
      Size(428, 926); // iPhone X dimensions as base

  late Size _uiSize;
  late Size _screenSize;
  late double _scaleWidth;
  late double _scaleHeight;

  static final ResponsiveUtil _instance = ResponsiveUtil._();
  factory ResponsiveUtil() => _instance;

  ResponsiveUtil._();

  void init(BuildContext context, {Size designSize = _defaultSize}) {
    _uiSize = designSize;
    _screenSize = MediaQuery.of(context).size;
    _scaleWidth = _screenSize.width / _uiSize.width;
    _scaleHeight = _screenSize.height / _uiSize.height;
  }

  double width(num width) => width * _scaleWidth;
  double height(num height) => height * _scaleHeight;
  double radius(num r) => r * min(_scaleWidth, _scaleHeight);
  double fontSize(num size) => size * min(_scaleWidth, _scaleHeight);

  double get scaleWidth => _scaleWidth;
  double get scaleHeight => _scaleHeight;

  // Screen size breakpoints
  bool get isMobile => _screenSize.width < 600;
  bool get isTablet => _screenSize.width >= 600 && _screenSize.width < 900;
  bool get isDesktop => _screenSize.width >= 900;

  // Helper method that returns the smallest scale factor
  double get scale => min(_scaleWidth, _scaleHeight);

  // Helper to get a proportionally sized widget
  double getProportionalHeight(double height) => height * _scaleHeight;
  double getProportionalWidth(double width) => width * _scaleWidth;

  // Adaptive sizing that caps at maximum values to prevent overly large elements
  double adaptiveWidth(double width, {double? max}) {
    final calculatedWidth = getProportionalWidth(width);
    return max != null ? min(calculatedWidth, max) : calculatedWidth;
  }

  double adaptiveHeight(double height, {double? max}) {
    final calculatedHeight = getProportionalHeight(height);
    return max != null ? min(calculatedHeight, max) : calculatedHeight;
  }
}

double min(double a, double b) => a < b ? a : b;
