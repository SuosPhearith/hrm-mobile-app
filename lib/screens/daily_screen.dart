import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/daily_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/shared/date/date_chooser.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
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
      providers: [ChangeNotifierProvider(create: (_) => DailyProvider())],
      child: Consumer2<SettingProvider, DailyProvider>(
        builder: (BuildContext context, settingProvider, dailyProvider, child) {
          return Scaffold(
            backgroundColor: Colors.white, // Clean, soft background
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
                    final dailyProvider = context.read<DailyProvider>();
                    dailyProvider.getHome(
                        startDate: startDate, endDate: endDate);
                  });
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
                          color: Colors.black,
                          fontSize: 16),
                    ),
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.sync, color: Colors.black),
                  onPressed: () {},
                  splashRadius: 20.0,
                ),
              ],
              bottom: CustomHeader(),
            ),
            body: dailyProvider.isLoading
                ? Skeleton()
                : SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: List.generate(
                            (dailyProvider.dailyProviderListData
                                    ?.data['results'] as List)
                                .length,
                            (index) {
                              final result = dailyProvider.dailyProviderListData
                                  ?.data['results'][index];

                              final checkIn =
                                  DateTime.tryParse(result['check_in']) ??
                                      DateTime.now();
                              final checkOut =
                                  DateTime.tryParse(result['check_out']) ??
                                      DateTime.now();
                              final workingHour =
                                  (result['working_hour'] as num)
                                      .toStringAsFixed(2);
                              final percentRaw = result['percentage'] as double;
                              final percent = percentRaw.clamp(0.0, 1.0);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildDailyCard(
                                  date:
                                      DateFormat('dd-MM-yyyy').format(checkIn),
                                  loginTime:
                                      DateFormat('HH:mm').format(checkIn),
                                  logoutTime:
                                      DateFormat('HH:mm').format(checkOut),
                                  hours: "$workingHour h",
                                  percent: percent.clamp(0.0, 1.0),
                                  workingHour: workingHour,
                                ),
                              );
                            },
                          ),
                        )),
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

  Widget _buildDailyCard({
    required String date,
    required String loginTime,
    required String logoutTime,
    required String hours,
    required double percent, // must be clamped between 0.0 and 1.0
    required String workingHour, // example: "7.50"
  }) {
    final workTime = double.tryParse(workingHour) ?? 0.0;
    final progressColor = workTime >= 8.0 ? HColors.green : Colors.orange;

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // ✅ Rounded blue bar
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
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: HColors.bluegrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: Icon(Icons.login,
                              color: HColors.bluegrey, size: 14.0)),
                      const SizedBox(width: 4.0),
                      Text(
                        loginTime,
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: HColors.bluegrey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: Icon(Icons.logout,
                              color: HColors.bluegrey, size: 14.0)),
                      const SizedBox(width: 4.0),
                      Text(
                        logoutTime,
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 5.0,
                          percent: percent.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[300],
                          progressColor: progressColor,
                          barRadius: const Radius.circular(4.0),
                          animation: true,
                          animationDuration: 500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          hours,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
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
