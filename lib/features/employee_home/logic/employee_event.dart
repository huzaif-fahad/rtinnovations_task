part of 'employee_bloc.dart';

@immutable
sealed class EmployeesEvent {}

final class EmployeesFetchEvent extends EmployeesEvent {
  EmployeesFetchEvent();
}

final class DeleteEmployeeEvent extends EmployeesEvent {
  final int employeeId;
  DeleteEmployeeEvent({
    required this.employeeId,
  });
}

final class UpdateEmployeeEvent extends EmployeesEvent {
  final String employeeToUpdateId;
  final Employee employee;
  UpdateEmployeeEvent({
    required this.employee,
    required this.employeeToUpdateId,
  });
}

final class AddEmployeeEvent extends EmployeesEvent {
  final Employee employee;
  AddEmployeeEvent({
    required this.employee,
  });
}
