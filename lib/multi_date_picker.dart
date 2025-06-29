import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MultiDatePicker extends StatefulWidget {
  final void Function(Set<DateTime>) onChanged;

  const MultiDatePicker({required this.onChanged});

  @override
  _MultiDatePickerState createState() => _MultiDatePickerState();
}

class _MultiDatePickerState extends State<MultiDatePicker> {
  Set<DateTime> _selectedDates = {};

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2020),
      lastDay: DateTime(2100),
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      ),
      selectedDayPredicate: (day) {
        return _selectedDates.any((d) => isSameDay(d, day));
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (_selectedDates.any((d) => isSameDay(d, selectedDay))) {
            _selectedDates.removeWhere((d) => isSameDay(d, selectedDay));
          } else {
            _selectedDates.add(selectedDay);
          }
          widget.onChanged(_selectedDates);
        });
      },
    );
  }
}
