import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/date/calendar_picker.dart';
import 'package:mobile_app/shared/date/kh_date_formmat.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final DateTime initialDate;
  final DateTime? selectedDate;
  final String? hint;
  final Function(DateTime) onDateSelected;

  const DateInputField({
    super.key,
    required this.label,
    required this.initialDate,
    required this.onDateSelected,
    this.selectedDate, this.hint,
  });
  void _openDatePicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomSingleDatePicker(initialDate: selectedDate),
      ),
    );

    if (result != null) {
      onDateSelected(result);
      // print("Selected date: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () => _openDatePicker(context),
      controller: TextEditingController(
        text: selectedDate != null
            ? KhmerDateFormatter.format(selectedDate!)
            : '',
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: Icon(Icons.calendar_today, color: HColors.darkgrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: HColors.darkgrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: HColors.darkgrey,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: HColors.darkgrey,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        // color: Colors.black87,
      ),
    );
  }
}