import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtinnovations_task/core/l10n/app_strings.dart';
import 'package:rtinnovations_task/core/themes/theme_handler.dart';
import 'package:rtinnovations_task/core/themes/typography/app_typography.dart';
import 'package:rtinnovations_task/features/employee_home/controllers/emp_controller.dart';
import 'package:rtinnovations_task/features/employee_home/logic/employee_bloc.dart';

import '../models/category.dart';
import 'widgets/empty_records.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  EmployeeController employeeController = EmployeeController();

  @override
  void initState() {
    employeeController.context = context;
    employeeController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.ofUntranslated(context).employeeListTitle,
            style: AppTypography.h5,
          ),
          backgroundColor: ThemeHandler.currentTheme.primaryColor,
        ),
        body: Center(
          child: BlocConsumer<EmployeesBloc, EmployeesState>(
            builder: (context, state) {
              return _stateWiseWidget(state);
            },
            listener: (context, state) {
              if (state is EmployeesError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ));
  }

  Widget _stateWiseWidget(EmployeesState state) {
    switch (state) {
      case EmployeesEmpty():
        return const EmptyRecords();

      case EmployeesLoading():
        return const Center(
          child: CircularProgressIndicator(),
        );

      case EmployeesLoaded():
        final employees = (state).employees;
        if (employees.isEmpty) {
          return const EmptyRecords();
        }
        // return a column with current employees list and previous employees list
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Current Employees",
              style: AppTypography.h5.apply(color: Colors.grey),
            ),
            // List of current employees

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employees[Category.current]?.length ?? 0,
              itemBuilder: (context, index) {
                final employee = employees[Category.current]![index];
                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text(employee.fromDate.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      employeeController.deleteEmployee(employee.id);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Previous Employees",
              style: AppTypography.h5.apply(color: Colors.grey),
            ),
            // List of previous employees
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employees[Category.previous]?.length ?? 0,
              itemBuilder: (context, index) {
                final employee = employees[Category.previous]![index];
                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text(employee.toDate.toString()),
                );
              },
            ),
            // Add your widget to display previous employees
          ],
        );
      default:
        return Center(
            child: Text(
          AppStrings.ofUntranslated(context).stateNotHandled,
        ));
    }
  }
}
