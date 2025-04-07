import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtinnovations_task/core/themes/default_theme.dart';
import 'package:rtinnovations_task/core/themes/typography/app_typography.dart';
import 'package:rtinnovations_task/features/employee_home/models/position.dart';
import 'package:rtinnovations_task/utils/extensions/colors_exs.dart';
import '../../models/employee.dart';

class EmployeeListTile extends StatelessWidget {
  final Employee employee;
  final Function(int) onDelete;
  final bool showDivider;

  const EmployeeListTile({
    super.key,
    required this.employee,
    required this.onDelete,
    this.showDivider = true,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Present';
    return DateFormat('d MMM, yyyy').format(date);
  }

  String _getDateRangeString() {
    final fromDate = _formatDate(employee.fromDate);
    final toDate = _formatDate(employee.toDate);
    return '$fromDate - $toDate';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: showDivider
              ? BorderSide(color: Colors.grey.shade300, width: 1.0)
              : BorderSide.none,
        ),
      ),
      child: Dismissible(
        key: Key('employee-${employee.id}'),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(employee.id),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.name,
                  style: AppTypography.h5
                      .copyWith(fontSize: 16, color: Colors.black)),
              const SizedBox(height: 8),
              Text(
                employee.position.displayName,
                style: AppTypography.body1
                    .copyWith(fontSize: 14, color: '#949C9E'.toColor()),
              ),
              const SizedBox(height: 8),
              Text(
                _getDateRangeString(),
                style: AppTypography.body1.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: '#949C9E'.toColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
