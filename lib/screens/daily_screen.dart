import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/daily_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/shared/date/date_chooser.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  DailyScreenState createState() => DailyScreenState();
}

class DailyScreenState extends State<DailyScreen> {
  DateTime? sselectedMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  // New variables for the updated date picker
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month - 1; // 0-based for khmerMonths
  late String displayMonth;
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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(DailyProvider provider) async {
    return await provider.getHome(
        startDate: _startDate?.toIso8601String().split('T')[0],
        endDate: _endDate?.toIso8601String().split('T')[0]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailyProvider(
          startDate: _startDate?.toIso8601String().split('T')[0],
          endDate: _endDate?.toIso8601String().split('T')[0]),
      child: Consumer2<DailyProvider, SettingProvider>(
          builder: (context, scanProvider, settingProvider, child) {
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
                        ? "ប្រចាំថ្ងៃ"
                        : "ប្រចាំថ្ងៃ - $displayMonth",
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
                    'សូមរងចាំ',
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
                                    ? Center(child: Text("គ្មានទិន្នន័យ"))
                                    : SizedBox(),
                                ...scanProvider.data?.data.results.map((record) {
                                      final scanIn = parseDateTime(getSafeString(
                                          value: record['check_in']));
                                      final scanOut = parseDateTime(getSafeString(
                                          value: record['check_out']));
                                      return _buildDailyCard(
                                          date: formatDate(getSafeString(
                                              value: record['date'])),
                                          hours: convertToHoursMinutes(
                                              value: record['working_hour']),
                                          loginTime: getSafeString(
                                              value: scanIn['time']),
                                          logoutTime: getSafeString(
                                              value: scanOut['time']),
                                          percent: clampToZeroOne(getSafeDouble(
                                              value: record['percentage'])));
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

  void _showMonthPicker(BuildContext context, DailyProvider provider) {
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

  Widget _buildDailyCard({
    required String date,
    required String loginTime,
    required String logoutTime,
    required String hours,
    required double percent,
  }) {
    // Extract working hours from the hours string to determine color
    final workingHoursMatch = RegExp(r'(\d+\.?\d*)').firstMatch(hours);
    final workingHours = workingHoursMatch != null
        ? double.tryParse(workingHoursMatch.group(1) ?? '0') ?? 0.0
        : 0.0;

    // Color logic: Green if >= 8 hours, Orange if < 8 hours
    final progressColor = workingHours >= 8.0 ? HColors.green : HColors.orange;

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 8.0,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: HColors.darkgrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(Icons.login,
                                  color: HColors.bluegrey, size: 14.0),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              loginTime,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 16.0),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: HColors.darkgrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(Icons.logout,
                                  color: HColors.bluegrey, size: 14.0),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              logoutTime,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height:15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(width: 1.0),
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 5.0,
                          percent: percent.clamp(0.0, 1.0),
                          backgroundColor: HColors.darkgrey.withOpacity(0.2),
                          progressColor: progressColor,
                          barRadius: const Radius.circular(4.0),
                          animation: true,
                          animationDuration: 500,
                        ),
                      ),
                      // const SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          hours,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            // color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
