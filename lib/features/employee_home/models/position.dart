enum Position {
  prodDesigner,
  flutterDev,
  qaTester,
  productOwner,
}

extension PositionExtension on Position {
  String get displayName {
    switch (this) {
      case Position.prodDesigner:
        return 'Product Designer';
      case Position.flutterDev:
        return 'Flutter Developer';
      case Position.qaTester:
        return 'QA Tester';
      case Position.productOwner:
        return 'Product Owner';
    }
  }

  static Position fromString(String value) {
    return Position.values.firstWhere(
      (position) => position.toString().split('.').last == value,
      orElse: () => Position.flutterDev,
    );
  }
}
