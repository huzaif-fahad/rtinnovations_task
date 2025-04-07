import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtinnovations_task/utils/db/local_db_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/abstracts/feature_controller.dart';
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

  ValueNotifier<bool> isBottomBarVisible = ValueNotifier(false);
  @override
  void init() {
    if (context == null) {
      throw Exception(
          'Context is not set. Please set the context before using.');
    }

    DatabaseHelper.instance.database.then((db) {});
    DatabaseHelper.instance.insertDummyData();
    BlocProvider.of<EmployeesBloc>(context!).add(EmployeesFetchEvent());
  }

  @override
  void dispose() {
    DatabaseHelper.instance.close();
    super.dispose();
  }

  void deleteEmployee(int id) {
    BlocProvider.of<EmployeesBloc>(context!)
        .add(DeleteEmployeeEvent(employeeId: id));
  }
}
