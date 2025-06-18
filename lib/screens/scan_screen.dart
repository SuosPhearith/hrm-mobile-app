import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/scan_provider.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/shared/date/date_chooser.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  DateTime? sselectedMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  // New variables for the updated date picker
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month - 1; // 0-based for khmerMonths
  late String displayMonth;
  @override
  void initState() {
    super.initState();
    // Initialize with current month and year
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month - 1; // 0-based index for khmerMonths
    displayMonth = khmerMonths[selectedMonth];
    sselectedMonth = DateTime(selectedYear, now.month, 1);
    _startDate = sselectedMonth;
    _endDate = DateTime(
        selectedYear, now.month, getLastDayOfMonth(selectedYear, now.month));
  }

  // Static month names that don't depend on context
  static const List<String> khmerMonths = [
    'មករា', // January
    'កុម្ភៈ', // February
    'មីនា', // March
    'មេសា', // April
    'ឧសភា', // May
    'មិថុនា', // June
    'កក្កដា', // July
    'សីហា', // August
    'កញ្ញា', // September
    'តុលា', // October
    'វិច្ឆិកា', // November
    'ធ្នូ', // December
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
  String getMonthName(int monthIndex, String? lang) {
    if (monthIndex < 0 || monthIndex > 11) return '';

    // Use Khmer as default, English if explicitly set to 'en'
    if (lang == 'en') {
      return englishMonths[monthIndex];
    } else {
      return khmerMonths[monthIndex];
    }
  }

  // Helper method to get both language month names
  String getBothLanguageMonths(int monthIndex, {String separator = ' / '}) {
    if (monthIndex < 0 || monthIndex > 11) return '';
    return '${englishMonths[monthIndex]}$separator${khmerMonths[monthIndex]}';
  }

  int getLastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(ScanProvider provider) async {
    return await provider.getHome(
        startDate: _startDate?.toIso8601String().split('T')[0],
        endDate: _endDate?.toIso8601String().split('T')[0]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanProvider(
          startDate: _startDate?.toIso8601String().split('T')[0],
          endDate: _endDate?.toIso8601String().split('T')[0]),
      child: Consumer2<ScanProvider, SettingProvider>(
          builder: (context, scanProvider, settingProvider, child) {
        final lang = Provider.of<SettingProvider>(context, listen: false).lang;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                _showMonthPicker(context, scanProvider);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayMonth.isEmpty
                        ? AppLang.translate(
                            lang: lang ?? 'kh', key: 'home_scan')
                        : "${AppLang.translate(lang: Provider.of<SettingProvider>(context, listen: false).lang ?? 'kh', key: 'home_scan')} - $displayMonth",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      // color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(Icons.arrow_drop_down, color: HColors.darkgrey),
                ],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            // iconTheme: const IconThemeData(
            //   color: HColors.darkgrey,
            // ),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.sync,
                  color: HColors.darkgrey,
                  size: 28.0,
                ),
                onPressed: () {
                  final lastDay =
                      getLastDayOfMonth(selectedYear, selectedMonth + 1);
                  final startDate =
                      '${selectedYear.toString().padLeft(4, '0')}-${(selectedMonth + 1).toString().padLeft(2, '0')}-01';
                  final endDate =
                      '${selectedYear.toString().padLeft(4, '0')}-${(selectedMonth + 1).toString().padLeft(2, '0')}-$lastDay';

                  scanProvider.getHome(
                    startDate: startDate,
                    endDate: endDate,
                  );
                },
                splashRadius: 20.0,
              ),
            ],
            bottom: CustomHeader(),
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.blue[800],
            backgroundColor: Colors.white,
            onRefresh: () => _refreshData(scanProvider),
            child: scanProvider.isLoading
                ? Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                        Text(
                          AppLang.translate(lang: lang ?? 'kh', key: 'waiting'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : scanProvider.data == null
                    ? Center(child: Text('Something went wrong'))
                    : SafeArea(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Display selected date range
                                // DateRangeSelector(
                                //   startDate: _startDate,
                                //   endDate: _endDate,
                                //   onTap: () {
                                //     _showMonthPicker(context, scanProvider);
                                //   },
                                // ),
                                scanProvider.data!.data.results.isEmpty
                                    ? Center(
                                        child: Text(AppLang.translate(
                                            lang: lang ?? 'kh',
                                            key: 'no data')))
                                    : SizedBox(),
                                ...scanProvider.data?.data.results
                                        .map((record) {
                                      final result = parseDateTime(
                                          getSafeString(
                                              value: record['datetime']));
                                      return _buildScanCard(
                                        type: getSafeString(
                                          value: AppLang.translate(
                                              data: record['terminal_device']
                                                  ['direction'],
                                              lang:
                                                  settingProvider.lang ?? 'kh'),
                                        ),
                                        location:
                                            '${getSafeString(value: record['terminal_device']['name'])} | ${getSafeString(value: record['terminal_device']['group'])}',
                                        time: getSafeString(
                                            value: result['time']),
                                        date: getSafeString(
                                            value: result['date']),
                                        icon: Icons.logout,
                                      );
                                    }).toList() ??
                                    [],
                                // SizedBox(
                                //     height:
                                //         MediaQuery.of(context).size.height * 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
        );
      }),
    );
  }
  void _showMonthPicker(BuildContext context, ScanProvider provider) {
    showMonthYearPicker(context, selectedYear, selectedMonth, (year, month) {
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
        // Update the existing date variables to maintain compatibility
        sselectedMonth = DateTime(year, month + 1, 1);
        _startDate = DateTime(year, month + 1, 1);
        _endDate = DateTime(year, month + 1, lastDay);
      });

      provider.getHome(
        startDate: startDate,
        endDate: endDate,
      );
    });
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
      margin: const EdgeInsets.symmetric(vertical: 6),
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
