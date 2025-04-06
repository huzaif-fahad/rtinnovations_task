part of 'employee_bloc.dart';

@immutable
sealed class EmployeesState {}

final class EmployeesEmpty extends EmployeesState {}

final class EmployeesLoading extends EmployeesState {}

final class EmployeesLoaded extends EmployeesState {
  final Map<String, List<Employee>> employees;
  final int page;
  final int totalPages;

  EmployeesLoaded({
    required this.employees,
    required this.page,
    required this.totalPages,
  });
}

final class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError({
    required this.message,
  });
}
