import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/shared/color/colors.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFCBD5E1),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
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
                  color: HColors.darkgrey,
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
                    fontWeight: FontWeight.w500,
                    // color: HColors.darkgrey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.edit,
              size: 20.0,
             color: HColors.darkgrey,
            ),
          ],
        ),
      ),
    );
  }
}
