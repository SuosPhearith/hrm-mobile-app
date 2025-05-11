import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onTap;

  const DateRangeSelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 24.0,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  startDate != null && endDate != null
                      ? "ពី ${DateFormat('dd-MM-yyyy').format(startDate!)} ដល់ ${DateFormat('dd-MM-yyyy').format(endDate!)}"
                      : "ជ្រើសរើសកាលបរិច្ឆេទ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.edit,
              size: 20.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
