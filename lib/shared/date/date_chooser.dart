import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:provider/provider.dart';

class MonthYearPickerContent extends StatefulWidget {
  final int initialYear;
  final int selectedMonth;
  final Function(int year, int month) onConfirm;

  const MonthYearPickerContent({
    super.key,
    required this.initialYear,
    required this.selectedMonth,
    required this.onConfirm,
  });

  @override
  State<MonthYearPickerContent> createState() => _MonthYearPickerContentState();
}

class _MonthYearPickerContentState extends State<MonthYearPickerContent> {
  late int year;
  late int selectedMonth;
   // Static month names
  static const List<String> khmerMonths = [
    'មករា',      // January
    'កុម្ភៈ',     // February
    'មីនា',      // March (fixed typo: was 'មិនា')
    'មេសា',      // April
    'ឧសភា',      // May
    'មិថុនា',     // June
    'កក្កដា',     // July
    'សីហា',      // August
    'កញ្ញា',      // September
    'តុលា',      // October
    'វិច្ឆិកា',    // November
    'ធ្នូ',       // December
  ];

  static const List<String> englishMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Helper method to get month name based on language
  String getMonthName(int monthIndex) {
    if (monthIndex < 0 || monthIndex > 11) return '';
    
    if (Provider.of<SettingProvider>(context,listen: false).lang == 'en') {
      return englishMonths[monthIndex];
    } else {
      return khmerMonths[monthIndex];
    }
  }

  // Helper method to get all month names for the current language
  List<String> getMonthNames() {
    if (Provider.of<SettingProvider>(context,listen: false).lang == 'en') {
      return englishMonths;
    } else {
      return khmerMonths;
    }
  }

  @override
  void initState() {
    super.initState();
    year = widget.initialYear;
    selectedMonth = widget.selectedMonth;
  }


  @override
  Widget build(BuildContext context) {
     final monthNames = getMonthNames();
     final lang = Provider.of<SettingProvider>(context,listen: false).lang;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => setState(() => year--),
                ),
                GestureDetector(
                  onTap: () {
                    _showYearPickerBottomSheet(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(Icons.calendar_month, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        '$year',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => setState(() => year++),
                ),
              ],
            ),
            Divider(
              color: HColors.darkgrey.withOpacity(0.1),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              itemCount: 12,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedMonth == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedMonth = index),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? HColors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      monthNames[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'KantumruyPro',
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
            Divider(
              color: HColors.darkgrey.withOpacity(0.1),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLang.translate(lang: lang??'kh',key:'close'),
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          HColors.blue, // 🔵 Set your desired color here
                    ),
                    onPressed: () {
                      widget.onConfirm(year, selectedMonth);
                      Navigator.pop(context);
                    },
                    child: Text(
                     AppLang.translate(lang: lang??'kh',key:'confirm'),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        int currentYear = DateTime.now().year;
        List<int> years = List.generate(10, (i) => currentYear - 5 + i);

        return ListView(
          shrinkWrap: true,
          children: years.map((y) {
            return ListTile(
              title: Text('$y'),
              onTap: () {
                setState(() {
                  year = y;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
