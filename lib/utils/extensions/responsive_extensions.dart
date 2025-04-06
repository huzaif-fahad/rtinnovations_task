import 'package:flutter/material.dart';
import '../responsive/responsive_util.dart';

extension ResponsiveExtension on num {
  // Width extensions
  double get w => ResponsiveUtil().width(this);

  // Height extensions
  double get h => ResponsiveUtil().height(this);

  // Font size extensions
  double get sp => ResponsiveUtil().fontSize(this);

  // Radius extensions
  double get r => ResponsiveUtil().radius(this);
}

extension ContextExtension on BuildContext {
  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // Check screen type
  bool get isMobile => ResponsiveUtil().isMobile;
  bool get isTablet => ResponsiveUtil().isTablet;
  bool get isDesktop => ResponsiveUtil().isDesktop;

  // Responsive padding
  EdgeInsets get defaultPadding => EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      );

  // Responsive scaffold padding - different padding based on device type
  EdgeInsets get scaffoldPadding => isMobile
      ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)
      : isTablet
          ? EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h)
          : EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h);
}

extension WidgetExtension on Widget {
  // Responsive padding wrapper
  Widget paddedSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal != null ? horizontal.w : 0,
        vertical: vertical != null ? vertical.h : 0,
      ),
      child: this,
    );
  }

  // Responsive padding wrapper for all sides
  Widget padded({double? left, double? top, double? right, double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
        left: left != null ? left.w : 0,
        top: top != null ? top.h : 0,
        right: right != null ? right.w : 0,
        bottom: bottom != null ? bottom.h : 0,
      ),
      child: this,
    );
  }
}
