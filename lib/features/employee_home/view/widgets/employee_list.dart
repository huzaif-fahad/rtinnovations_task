import 'package:flutter/material.dart';
import 'package:rtinnovations_task/core/l10n/app_strings.dart' show AppStrings;
import '../../controllers/emp_controller.dart';
import '../../models/category.dart';
import '../../../../utils/extensions/responsive_exs.dart';
import '../../../../core/themes/typography/app_typography.dart';
import '../../models/employee.dart';
import 'emp_list_tile.dart';

class EmployeeListWidget extends StatelessWidget {
  const EmployeeListWidget(
      {super.key, required this.employees, required this.employeeController});

  final Map<Category, List<Employee>> employees;
  final EmployeeController employeeController;

  @override
  Widget build(BuildContext context) {
    final hasCurrentEmployees =
        employees[Category.current]?.isNotEmpty ?? false;
    final hasPreviousEmployees =
        employees[Category.previous]?.isNotEmpty ?? false;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          if (hasCurrentEmployees) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                color: Colors.grey.shade200,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  AppStrings.ofUntranslated(context).currentEmployees,
                  style: AppTypography.h6,
                ),
              ),
            ),
            ...List.generate(
              employees[Category.current]?.length ?? 0,
              (index) {
                final employee = employees[Category.current]![index];
                return EmployeeListTile(
                  employee: employee,
                  onDelete: (id) {
                    employeeController.deleteEmployee(id);
                  },
                  showDivider:
                      index != (employees[Category.current]!.length - 1),
                );
              },
            ),
          ],
          if (hasPreviousEmployees) ...[
            Padding(
              padding: EdgeInsets.only(
                  top: hasCurrentEmployees ? 16.h : 0, bottom: 8.h),
              child: Container(
                color: Colors.grey.shade200,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  AppStrings.ofUntranslated(context).previousEmployees,
                  style: AppTypography.h6,
                ),
              ),
            ),
            ...List.generate(
              employees[Category.previous]?.length ?? 0,
              (index) {
                final employee = employees[Category.previous]![index];
                return EmployeeListTile(
                  employee: employee,
                  onDelete: (id) {
                    employeeController.deleteEmployee(id);
                  },
                  showDivider:
                      index != (employees[Category.previous]!.length - 1),
                );
              },
            ),
          ],
          if (!hasCurrentEmployees && !hasPreviousEmployees)
            const SizedBox.shrink(),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
