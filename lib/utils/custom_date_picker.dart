import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtinnovations_task/features/employee_home/view/employee_home.dart';
import 'package:rtinnovations_task/utils/extensions/responsive_exs.dart';

import '../core/themes/theme_handler.dart';
import '../core/themes/typography/app_typography.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;
  // Add customizable quick selections
  final List<Map<String, dynamic>>? quickSelections;

  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    this.quickSelections,
  });

  static Future<DateTime?> show(BuildContext context,
      {DateTime? initialDate,
      List<Map<String, dynamic>>? quickSelections}) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: CustomDatePicker(
            initialDate: initialDate ?? DateTime.now(),
            quickSelections: quickSelections,
            onDateSelected: (date) {
              Navigator.of(context).pop(date);
            },
          ),
        );
      },
    );
  }

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  // ValueNotifier for reactive state management
  late final ValueNotifier<DateTime> _selectedDateNotifier;
  late final ValueNotifier<DateTime> _currentMonthNotifier;
  late PageController _pageController;

  // Default quick selections if none provided
  late final List<Map<String, dynamic>> _quickSelections;

  @override
  void initState() {
    super.initState();
    _selectedDateNotifier = ValueNotifier(widget.initialDate ?? DateTime.now());
    _currentMonthNotifier = ValueNotifier(DateTime(
        _selectedDateNotifier.value.year,
        _selectedDateNotifier.value.month,
        1));
    _pageController = PageController(initialPage: 0);

    // Initialize quick selections with defaults or custom options
    _quickSelections = widget.quickSelections ??
        [
          {
            'label': 'Today',
            'date': DateTime.now(),
            'color': Colors.blue.shade50,
          },
          {
            'label': 'Next Monday',
            'date': _getNextMonday(),
            'color': Colors.blue.shade50,
          },
          {
            'label': 'Next Tuesday',
            'date': _getNextTuesday(),
            'color': Colors.blue.shade50,
          },
          {
            'label':
                'After 2 weeks', // Changed to avoid overlap with Next Monday
            'date': DateTime.now().add(const Duration(days: 14)),
            'color': Colors.blue.shade50,
          },
        ];
  }

  @override
  void dispose() {
    _selectedDateNotifier.dispose();
    _currentMonthNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    final current = _currentMonthNotifier.value;
    _currentMonthNotifier.value = DateTime(current.year, current.month - 1, 1);
  }

  void _nextMonth() {
    final current = _currentMonthNotifier.value;
    _currentMonthNotifier.value = DateTime(current.year, current.month + 1, 1);
  }

  void _selectDate(DateTime date) {
    _selectedDateNotifier.value = date;
  }

  DateTime _getNextMonday() {
    // Get next Monday (not this Monday if today is Monday)
    DateTime now = DateTime.now();
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday <= 0) {
      daysUntilMonday += 7;
    }
    return now.add(Duration(days: daysUntilMonday));
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now();
    int daysUntilTuesday = DateTime.tuesday - now.weekday;
    if (daysUntilTuesday <= 0) {
      daysUntilTuesday += 7;
    }
    return now.add(Duration(days: daysUntilTuesday));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick Date Selections
          ValueListenableBuilder<DateTime>(
              valueListenable: _selectedDateNotifier,
              builder: (context, selectedDate, _) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _quickDateButton(
                            _quickSelections[0]['label'],
                            _quickSelections[0]['date'],
                            _quickSelections[0]['color'],
                            selectedDate,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _quickDateButton(
                            _quickSelections[1]['label'],
                            _quickSelections[1]['date'],
                            _quickSelections[1]['color'],
                            selectedDate,
                            defaultTextColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _quickDateButton(
                            _quickSelections[2]['label'],
                            _quickSelections[2]['date'],
                            _quickSelections[2]['color'],
                            selectedDate,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _quickDateButton(
                            _quickSelections[3]['label'],
                            _quickSelections[3]['date'],
                            _quickSelections[3]['color'],
                            selectedDate,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          const SizedBox(height: 20),

          // Month Navigation
          ValueListenableBuilder<DateTime>(
            valueListenable: _currentMonthNotifier,
            builder: (context, currentMonth, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.grey),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(currentMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.grey),
                    onPressed: _nextMonth,
                  ),
                ],
              );
            },
          ),

          // Day Labels
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sun', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Mon', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Tue', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Wed', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Thu', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Fri', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Sat', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Calendar Grid
          ValueListenableBuilder<DateTime>(
            valueListenable: _currentMonthNotifier,
            builder: (context, currentMonth, _) {
              return ValueListenableBuilder<DateTime>(
                valueListenable: _selectedDateNotifier,
                builder: (context, selectedDate, _) {
                  return _buildCalendarGrid(currentMonth, selectedDate);
                },
              );
            },
          ),

          const SizedBox(height: 16),

          // Selected Date Display
          ValueListenableBuilder<DateTime>(
            valueListenable: _selectedDateNotifier,
            builder: (context, selectedDate, _) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue.shade400),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('d MMM yyyy').format(selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 74.w,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTypography.h5.copyWith(
                          color: ThemeHandler.currentTheme.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 74.w,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onDateSelected(_selectedDateNotifier.value);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: AppTypography.h5.copyWith(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _quickDateButton(
      String label, DateTime date, Color defaultColor, DateTime selectedDate,
      {Color defaultTextColor = Colors.black}) {
    bool isSelected = selectedDate.year == date.year &&
        selectedDate.month == date.month &&
        selectedDate.day == date.day;

    Color backgroundColor = isSelected ? Colors.blue : defaultColor;
    Color textColor = isSelected ? Colors.white : defaultTextColor;

    return InkWell(
      onTap: () => _selectDate(date),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime currentMonth, DateTime selectedDate) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);

    final firstDayIndex = firstDayOfMonth.weekday % 7;

    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    final totalDays = firstDayIndex + daysInMonth;
    final rowCount = (totalDays / 7).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: rowCount * 7,
      itemBuilder: (context, index) {
        final dayOffset = index - firstDayIndex;
        final day = dayOffset + 1;

        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(currentMonth.year, currentMonth.month, day);
        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;
        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

        return GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : (isToday ? Colors.white : null),
              border: isToday && !isSelected
                  ? Border.all(color: Colors.blue)
                  : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
