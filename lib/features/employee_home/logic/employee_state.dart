part of 'employee_bloc.dart';

@immutable
sealed class EmployeesState {}

final class EmployeesEmpty extends EmployeesState {}

final class EmployeesLoading extends EmployeesState {}

final class EmployeesLoaded extends EmployeesState {
  final Map<cat.Category, List<Employee>> employees;

  EmployeesLoaded({
    required this.employees,
  });

  EmployeesLoaded copyWith({
    Map<cat.Category, List<Employee>>? employees,
  }) {
    return EmployeesLoaded(
      employees: employees ?? this.employees,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmployeesLoaded && mapEquals(other.employees, employees);
  }

  @override
  int get hashCode => employees.hashCode;
}

final class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError({
    required this.message,
  });
}
