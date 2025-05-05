import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/scan_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/shared/date/date_chooser.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedMonth;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month - 1; // 0-based for khmerMonths
  String displayMonth = '';
  String startDate = '';
  String endDate = '';
  final List<String> khmerMonths = [
    'មករា',
    'កុម្ភៈ',
    'មីនា',
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

  int getLastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ScanProvider())],
      child: Consumer2<ScanProvider, SettingProvider>(
        builder: (BuildContext context, scanProvider, settingProvider, child) {
          final lang = settingProvider.lang;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: GestureDetector(
                onTap: () {
                  showMonthYearPicker(context, selectedYear, selectedMonth,
                      (year, month) {
                    final khMonth = khmerMonths[month];
                    final lastDay = getLastDayOfMonth(year, month + 1);

                    final startDate =
                        '${year.toString().padLeft(4, '0')}-${(month + 1).toString().padLeft(2, '0')}-01';
                    final endDate =
                        '${year.toString().padLeft(4, '0')}-${(month + 1).toString().padLeft(2, '0')}-$lastDay';

                    setState(() {
                      selectedYear = year;
                      selectedMonth = month;
                      displayMonth = khMonth;
                    });

                    // ✅ Call getHome() with selected dates
                    final scanProvider = context.read<ScanProvider>();
                    scanProvider.getHome(
                        startDate: startDate, endDate: endDate);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayMonth.isEmpty ? "ស្កេន" : "ស្កេន - $displayMonth",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                    //                     Text(
                    //   AppLang.translate(
                    //     key: displayMonth.isEmpty
                    //         ? 'home_scan'
                    //         : '${displayMonth.split(" ").first}',
                    //     lang: lang ?? 'kh',
                    //   ),
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.black,
                    //   ),
                    // ),

                    const SizedBox(width: 4.0),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       Icons.sync,
              //       color: Colors.black,
              //       size: 28.0,
              //     ),
              //     onPressed: () {},
              //     splashRadius: 20.0,
              //   ),
              // ],
              bottom: CustomHeader(),
            ),
            body: scanProvider.isLoading
                ? Skeleton()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: List.generate(
                          (scanProvider.scanListData?.data['results'] as List)
                              .length,
                          (index) {
                            final result = scanProvider
                                .scanListData?.data['results'][index];

                            final direction =
                                result['terminal_device']['direction'];
                            final device = result['terminal_device'];
                            final datetime =
                                DateTime.tryParse(result['datetime']) ??
                                    DateTime.now();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildScanCard(
                                type: lang == 'en'
                                    ? direction['name_en']
                                    : direction['name_kh'],

                                location:
                                    '${device['name']} | ${device['group']}',
                                time: DateFormat('hh:mm a')
                                    .format(datetime), // e.g., 05:00 PM
                                date: DateFormat('dd-MM-yyyy')
                                    .format(datetime), // e.g., 12-02-2025
                                icon: Icons.logout,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  void showMonthYearPicker(
    BuildContext context,
    int initialYear,
    int selectedMonth,
    Function(int year, int month) onConfirm,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => MonthYearPickerContent(
        initialYear: initialYear,
        selectedMonth: selectedMonth,
        onConfirm: onConfirm,
      ),
    );
  }


  Widget _buildScanCard({
    required String type,
    required String location,
    required String time,
    required String date,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border:
              Border.all(color: HColors.darkgrey.withOpacity(0.5), width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [Colors.blue[100]!, Colors.blue[200]!],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    color: HColors.bluegrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: HColors.bluegrey,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  // color: Colors.blue[800],
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12.0,
                  color: HColors.darkgrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
