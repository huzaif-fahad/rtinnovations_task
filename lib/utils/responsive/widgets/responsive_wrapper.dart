import 'package:flutter/material.dart';
import '../../extensions/responsive_extensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isDesktop && desktop != null) {
          return desktop!;
        } else if (context.isTablet && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
          BuildContext context, bool isMobile, bool isTablet, bool isDesktop)
      builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final isDesktop = context.isDesktop;

    return builder(context, isMobile, isTablet, isDesktop);
  }
}

class ResponsiveConstrainedBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
