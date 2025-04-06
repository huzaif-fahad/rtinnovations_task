import 'position.dart';

class Employee {
  final String id;
  final String name;
  final Position position;
  final DateTime? fromDate;
  final DateTime? toDate;

  const Employee({
    required this.id,
    required this.name,
    required this.position,
    this.fromDate,
    this.toDate,
  });

  // Factory constructor for deserialization
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      position: Position.values.firstWhere(
        (e) => e.toString().split('.').last == json['position'],
      ),
      fromDate:
          json['fromDate'] != null ? DateTime.parse(json['fromDate']) : null,
      toDate: json['toDate'] != null ? DateTime.parse(json['toDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position.toString().split('.').last,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
    };
  }

  Employee copyWith({
    String? name,
    Position? position,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearFromDate = false,
    bool clearToDate = false,
  }) {
    return Employee(
      name: name ?? this.name,
      id: id,
      position: position ?? this.position,
      fromDate: clearFromDate ? null : fromDate ?? this.fromDate,
      toDate: clearToDate ? null : toDate ?? this.toDate,
    );
  }

  @override
  String toString() {
    return 'Employee(name: $name, position: $position, fromDate: $fromDate, toDate: $toDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Employee &&
        other.name == name &&
        other.position == position &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode =>
      name.hashCode ^ position.hashCode ^ fromDate.hashCode ^ toDate.hashCode;
}
