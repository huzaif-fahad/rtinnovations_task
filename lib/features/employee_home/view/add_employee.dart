// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtinnovations_task/features/employee_home/logic/employee_bloc.dart';
import 'package:rtinnovations_task/features/employee_home/models/employee.dart';

import '../controllers/emp_controller.dart';
import '../models/position.dart';

class AddEmployee extends StatefulWidget {
  final EmployeeController controller;

  const AddEmployee({
    super.key,
    required this.controller,
  });

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController _nameController = TextEditingController();
  late final ValueNotifier<Position> _positionNotifier;
  late final ValueNotifier<bool> _isBottomSheetVisibleNotifier;

  EmployeeController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _positionNotifier = ValueNotifier(Position.flutterDev);
    _isBottomSheetVisibleNotifier = _controller.isBottomBarVisible;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionNotifier.dispose();
    super.dispose();
  }

  void _showPositionBottomSheet() {
    _isBottomSheetVisibleNotifier.value = true;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ValueListenableBuilder<Position>(
              valueListenable: _positionNotifier,
              builder: (context, selectedPosition, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: Position.values.map((Position position) {
                    return Column(
                      children: [
                        ListTile(
                          title: Center(
                            child: Text(
                              position.displayName,
                              style: TextStyle(
                                color: selectedPosition == position
                                    ? Colors.blue
                                    : Colors.black,
                                fontWeight: selectedPosition == position
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          onTap: () {
                            _positionNotifier.value = position;
                            Navigator.pop(context);
                          },
                        ),
                        if (position != Position.values.last)
                          const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                );
              }),
        );
      },
    ).whenComplete(() {
      _isBottomSheetVisibleNotifier.value = false;
    });
  }

  void _showStartDatePicker() async {
    _controller.showStartDatePicker(context);
  }

  void _showEndDatePicker() async {
    _controller.showEndDatePicker(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee Details'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.blue.shade400),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Employee Name',
                            border: InputBorder.none,
                          ),
                          autofocus: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Role selector
              GestureDetector(
                onTap: _showPositionBottomSheet,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16.0),
                    child: ValueListenableBuilder<Position>(
                        valueListenable: _positionNotifier,
                        builder: (context, position, _) {
                          return Row(
                            children: [
                              Icon(Icons.work_outline,
                                  color: Colors.blue.shade400),
                              const SizedBox(width: 8),
                              Text(position.displayName),
                              const Spacer(),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          );
                        }),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date selectors
              Row(
                children: [
                  // Start date selector
                  Expanded(
                    child: ValueListenableBuilder<DateTime?>(
                        valueListenable: _controller.startDateNotifier,
                        builder: (context, startDate, _) {
                          return GestureDetector(
                            onTap: _showStartDatePicker,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.blue.shade400),
                                  const SizedBox(width: 8),
                                  Text(
                                    startDate != null
                                        ? DateFormat('d MMM yyyy')
                                            .format(startDate)
                                        : 'Select Start Date',
                                    style: TextStyle(
                                      color: startDate != null
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),

                  // Arrow between dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Icon(Icons.arrow_forward, color: Colors.blue.shade300),
                  ),

                  // End date selector
                  Expanded(
                    child: ValueListenableBuilder<DateTime?>(
                        valueListenable: _controller.endDateNotifier,
                        builder: (context, endDate, _) {
                          return GestureDetector(
                            onTap: _showEndDatePicker,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: Colors.blue.shade400),
                                  const SizedBox(width: 8),
                                  Text(
                                    endDate != null
                                        ? DateFormat('d MMM yyyy')
                                            .format(endDate)
                                        : 'No date',
                                    style: TextStyle(
                                      color: endDate != null
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: TextButton(
                onPressed: () {
                  context.go('/home');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  // Save logic would go here
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter employee name')),
                    );
                    return;
                  }
                  if (_controller.startDateNotifier.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select a start date')),
                    );
                    return;
                  }
                  int id = await _controller.genIderateId();
                  BlocProvider.of<EmployeesBloc>(context!).add(
                    AddEmployeeEvent(
                      employee: Employee(
                        id: id,
                        name: _nameController.text,
                        position: _positionNotifier.value,
                        fromDate: _controller.startDateNotifier.value,
                        toDate: _controller.endDateNotifier.value,
                      ),
                    ),
                  );

                  context.go(
                    '/home',
                    extra: _controller,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
