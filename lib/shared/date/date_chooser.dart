import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

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
  final List<String> khmerMonths = [
    'មករា',
    'កុម្ភៈ',
    'មិនា',
    'មេសា',
    'ឧសភា',
    'មិថុនា',
    'កក្កដា',
    'សីហា',
    'កញ្ញា',
    'តុលា',
    'វិច្ឆិកា',
    'ធ្នូ',
  ];

  @override
  void initState() {
    super.initState();
    year = widget.initialYear;
    selectedMonth = widget.selectedMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        fontFamily: 'Kantumruy Pro',
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
                    khmerMonths[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kantumruy Pro',
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
                    "បិត",
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
                    "យល់ព្រម",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
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
