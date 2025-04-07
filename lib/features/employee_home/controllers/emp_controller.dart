import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtinnovations_task/features/employee_home/models/employee.dart';
import 'package:rtinnovations_task/utils/db/local_db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/abstracts/feature_controller.dart';
import '../../../utils/custom_date_picker.dart';
import '../logic/employee_bloc.dart';

class EmployeeController extends FeatureController {
  //Singleton instance
  static final EmployeeController _instance = EmployeeController._internal();

  factory EmployeeController() {
    return _instance;
  }

  EmployeeController._internal();

  BuildContext? context;
  Database? database;

  // ValueNotifiers for UI state
  ValueNotifier<bool> isBottomBarVisible = ValueNotifier(false);
  ValueNotifier<DateTime?> startDateNotifier = ValueNotifier(null);
  ValueNotifier<DateTime?> endDateNotifier = ValueNotifier(null);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void init() {
    if (context == null) {
      throw Exception(
          'Context is not set. Please set the context before using.');
    }
    DatabaseHelper.instance.database.then((db) {
      database = db;
    });
    BlocProvider.of<EmployeesBloc>(context!).add(EmployeesFetchEvent());
  }

  @override
  void dispose() {
    // Dispose all ValueNotifiers
    isBottomBarVisible.dispose();
    startDateNotifier.dispose();
    endDateNotifier.dispose();
    isLoading.dispose();

    DatabaseHelper.instance.close();
    super.dispose();
  }

  void deleteEmployee(int id) {
    BlocProvider.of<EmployeesBloc>(context!)
        .add(DeleteEmployeeEvent(employeeId: id));
  }

  Future<int> genIderateId() async {
    // Generate a unique ID for the new employee
    var result =
        await database!.query('employees', columns: ['MAX(id) as max_id']);

    int? maxId = result.isNotEmpty ? result.first['max_id'] as int? : 0;

    int newId = maxId ?? 0 + 1;

    return newId;
  }

  void showStartDatePicker(BuildContext context) async {
    final pickedDate = await CustomDatePicker.show(
      context,
      initialDate: startDateNotifier.value ?? DateTime.now(),
    );

    if (pickedDate != null) {
      startDateNotifier.value = pickedDate;
      if (endDateNotifier.value != null &&
          endDateNotifier.value!.isBefore(pickedDate)) {
        endDateNotifier.value = null;
      }
    }
  }

  void showEndDatePicker(BuildContext context) async {
    // Don't show picker if no start date is selected
    if (startDateNotifier.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date first')),
      );
      return;
    }

    final pickedDate = await CustomDatePicker.show(
      context,
      initialDate: endDateNotifier.value ?? startDateNotifier.value,
      minDate: startDateNotifier.value, // Disable dates before start date
      quickSelections: [
        {
          'label': 'No Date',
          'date': null,
          'color': Colors.blue.shade50,
        },
        {
          'label': 'Today',
          'date': DateTime.now(),
          'color': Colors.blue.shade50,
        },
        {
          'label': '', // Empty slot
          'date': DateTime.now(),
          'color': Colors.transparent,
          'enabled': false,
        },
        {
          'label': '', // Empty slot
          'date': DateTime.now(),
          'color': Colors.transparent,
          'enabled': false,
        },
      ],
    );

    if (pickedDate != null) {
      endDateNotifier.value = pickedDate;
    }
  }

  void resetDateValues() {
    startDateNotifier.value = null;
    endDateNotifier.value = null;
  }
}
