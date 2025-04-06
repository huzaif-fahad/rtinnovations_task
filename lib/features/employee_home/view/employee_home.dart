import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtinnovations_task/core/l10n/app_strings.dart';
import 'package:rtinnovations_task/core/themes/theme_handler.dart';
import 'package:rtinnovations_task/core/themes/typography/app_typography.dart';
import 'package:rtinnovations_task/features/employee_home/logic/employee_bloc.dart';

import 'widgets/empty_records.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeesBloc(),
      child: Scaffold(
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
          )),
    );
  }

  Widget _stateWiseWidget(EmployeesState state) {
    switch (state) {
      case EmployeesEmpty():
        return const EmptyRecords();
      default:
        return Center(
            child: Text(
          AppStrings.ofUntranslated(context).stateNotHandled,
        ));
    }
  }
}
