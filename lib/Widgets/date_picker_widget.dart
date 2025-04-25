import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final String buttonText;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final void Function(DateTime?) onDateSelected;
  final DateTime? initialValue; // Add this

  const DatePickerWidget({
    Key? key,
    required this.buttonText,
    required this.prefixIcon,
    required this.prefixIconColor,
    required this.onDateSelected,
    this.initialValue, // Add this
  }) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;
  bool showCalendar = false;

  static const EdgeInsetsGeometry _buttonPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  static const int _firstYear = 2000;
  static const int _lastYear = 2100;

  String get formattedDate {
    if (selectedDate == null) return widget.buttonText;

    final formatter = DateFormat('dd/MM/yyyy');
    return '${widget.buttonText}: ${formatter.format(selectedDate!)}';
  }

  void _toggleCalendar() {
    setState(() {
      showCalendar = !showCalendar;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      showCalendar = false;
    });
    widget.onDateSelected(date); // AGREGADO
  }

  void _clearDate() {
    setState(() {
      selectedDate = null;
    });
    widget.onDateSelected(null); // AGREGADO
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateButton(),
        if (showCalendar) _buildCalendarPicker(),
      ],
    );
  }

  Widget _buildDateButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: _toggleCalendar,
        style: ElevatedButton.styleFrom(
          padding: _buttonPadding,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide.none,
          minimumSize: const Size.fromHeight(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.prefixIcon, color: widget.prefixIconColor),
                const SizedBox(width: 12),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600]!,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (selectedDate != null)
              IconButton(
                onPressed: _clearDate,
                icon: Icon(Icons.clear, color: Colors.grey[600]),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarPicker() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CalendarDatePicker(
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(_firstYear),
          lastDate: DateTime(_lastYear),
          onDateChanged: _selectDate,
        ),
      ),
    );
  }
}
