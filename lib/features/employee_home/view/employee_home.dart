import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtinnovations_task/core/l10n/app_strings.dart';
import 'package:rtinnovations_task/core/themes/theme_handler.dart';
import 'package:rtinnovations_task/core/themes/typography/app_typography.dart';
import 'package:rtinnovations_task/features/employee_home/controllers/emp_controller.dart';
import 'package:rtinnovations_task/features/employee_home/logic/employee_bloc.dart';
import 'package:rtinnovations_task/features/employee_home/view/widgets/employee_list.dart';
import 'package:rtinnovations_task/utils/extensions/colors_exs.dart';
import 'package:rtinnovations_task/utils/extensions/responsive_exs.dart';
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
    employeeController.context = context;
    return Scaffold(
        backgroundColor: ('#F2F2F2').toColor(),
        appBar: AppBar(
          title: Text(
            AppStrings.ofUntranslated(context).employeeListTitle,
            style: AppTypography.h5.apply(),
          ),
          backgroundColor: ThemeHandler.currentTheme.primaryColor,
        ),
        floatingActionButton: ValueListenableBuilder(
            valueListenable: employeeController.isBottomBarVisible,
            builder: (c, v, ch) {
              return !v
                  ? FloatingActionButton(
                      onPressed: () {
                        context.go('/add-empl', extra: employeeController);
                      },
                      backgroundColor: ThemeHandler.currentTheme.primaryColor,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox.shrink();
            }),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: employeeController.isBottomBarVisible,
          builder: (context, value, child) {
            return value ? child! : const SizedBox.shrink();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.ofUntranslated(context).swipeToDelete,
                  style: AppTypography.body1.apply(),
                ),
                FloatingActionButton(
                  onPressed: () {
                    context.go('/add-empl', extra: employeeController);
                  },
                  elevation: 0,
                  backgroundColor: ThemeHandler.currentTheme.primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: BlocConsumer<EmployeesBloc, EmployeesState>(
          builder: (context, state) {
            return _stateWiseWidget(state);
          },
          listener: (context, state) {
            if (state is EmployeesError) {
              employeeController.isBottomBarVisible.value = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is EmployeesLoaded) {
              state.employees.isNotEmpty
                  ? employeeController.isBottomBarVisible.value = true
                  : employeeController.isBottomBarVisible.value = false;
            } else {
              employeeController.isBottomBarVisible.value = false;
            }
          },
        ));
  }

  Widget _stateWiseWidget(EmployeesState state) {
    switch (state) {
      case EmployeesEmpty():
        return const Center(child: EmptyRecords());

      case EmployeesLoading():
        return const Center(
          child: CircularProgressIndicator(),
        );

      case EmployeesLoaded():
        final employees = (state).employees;
        if (employees.isEmpty) {
          return const EmptyRecords();
        }

        return EmployeeListWidget(
          employees: employees,
          employeeController: employeeController,
        );

      case EmployeesError():
        return Center(
          child: Text(
            AppStrings.ofUntranslated(context).errorOccured + (state).message,
          ),
        );

      default:
        return Center(
            child: Text(
          AppStrings.ofUntranslated(context).stateNotHandled,
        ));
    }
  }
}
