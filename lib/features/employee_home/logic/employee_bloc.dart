import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../models/employee.dart';
import '../../../utils/db/local_db_helper.dart';

import '../models/category.dart' as cat;
part 'employee_event.dart';
part 'employee_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  EmployeesBloc() : super(EmployeesEmpty()) {
    on<EmployeesFetchEvent>(
        (event, emit) async => await _fetchCategoricalEmployees(event, emit));

    on<AddEmployeeEvent>(
        (event, emit) async => await _addEmployee(event, emit));

    on<DeleteEmployeeEvent>(
        (event, emit) async => await _deleteEmployee(event, emit));

    on<UpdateEmployeeEvent>(
        (event, emit) async => await _updateEmployee(event, emit));
  }

  Future<void> _fetchCategoricalEmployees(
      EmployeesFetchEvent event, Emitter<EmployeesState> emit) async {
    try {
      emit(EmployeesLoading());

      final db = DatabaseHelper.instance;
      final results =
          await db.query('SELECT * FROM employees ORDER BY name ASC');

      if (results.isEmpty) {
        emit(EmployeesEmpty());
        return;
      }

      final allEmployees =
          results.map((map) => Employee.fromJson(map)).toList();
      if (kDebugMode) {
        print("All Employees: ${allEmployees.length}");
      }

      final Map<cat.Category, List<Employee>> categorizedEmployees = {
        cat.Category.current: [],
        cat.Category.previous: []
      };

      final now = DateTime.now();

      for (var employee in allEmployees) {
        if (employee.toDate == null || employee.toDate!.isAfter(now)) {
          categorizedEmployees[cat.Category.current]!.add(employee);
        } else {
          categorizedEmployees[cat.Category.previous]!.add(employee);
        }
      }
      emit(EmployeesLoaded(employees: categorizedEmployees));
    } catch (error) {
      emit(EmployeesError(message: error.toString()));
    }
  }

  Future<void> _addEmployee(
      AddEmployeeEvent event, Emitter<EmployeesState> emit) async {
    try {
      emit(EmployeesLoading());

      final db = DatabaseHelper.instance;

      final Map<String, dynamic> employeeData = event.employee.toJson();

      await db.insert('employees', employeeData);

      if (kDebugMode) {
        print("Employee added: ${event.employee.toJson()}");
      }

      add(EmployeesFetchEvent());
    } catch (error) {
      emit(EmployeesError(
          message: 'Failed to add employee: ${error.toString()}'));
    }
  }

  Future<void> _updateEmployee(
      UpdateEmployeeEvent event, Emitter<EmployeesState> emit) async {
    try {
      emit(EmployeesLoading());

      final db = DatabaseHelper.instance;

      await db.update(
          'employees', event.employee.toJson(), 'id = ?', [event.employee.id]);

      add(EmployeesFetchEvent());
    } catch (error) {
      emit(EmployeesError(
          message: 'Failed to update employee: ${error.toString()}'));
    }
  }

  Future<void> _deleteEmployee(
      DeleteEmployeeEvent event, Emitter<EmployeesState> emit) async {
    try {
      emit(EmployeesLoading());

      final db = DatabaseHelper.instance;

      await db.delete('employees', 'id = ?', [event.employeeId]);

      add(EmployeesFetchEvent());
    } catch (error) {
      emit(EmployeesError(
          message: 'Failed to delete employee: ${error.toString()}'));
    }
  }
}
