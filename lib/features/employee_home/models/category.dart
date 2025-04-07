enum Category { current, previous }

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.current:
        return 'Current Employees';
      case Category.previous:
        return 'Previous Employees';
    }
  }
}
