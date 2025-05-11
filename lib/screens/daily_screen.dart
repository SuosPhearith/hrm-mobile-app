import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/daily_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/date_range_selector.dart';
import 'package:mobile_app/widgets/month_picker_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  DailyScreenState createState() => DailyScreenState();
}

class DailyScreenState extends State<DailyScreen> {
  DateTime? _selectedMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Use current month as default
    final now = DateTime.now();
    _selectedMonth = now;

    // Set start date to first day of current month
    _startDate = DateTime(now.year, now.month, 1);
    // Set end date to last day of current month
    _endDate = DateTime(now.year, now.month + 1, 0);
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
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                _showMonthPicker(context, scanProvider);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ប្រចាំថ្ងៃ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
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
                icon: const Icon(
                  Icons.date_range,
                  color: Colors.black,
                  size: 28.0,
                ),
                onPressed: () {
                  _showMonthPicker(context, scanProvider);
                },
                splashRadius: 20.0,
              ),
            ],
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.blue[800],
            backgroundColor: Colors.white,
            onRefresh: () => _refreshData(scanProvider),
            child: scanProvider.isLoading
                ? Center(child: Text('Loading...'))
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Display selected date range
                          DateRangeSelector(
                            startDate: _startDate,
                            endDate: _endDate,
                            onTap: () {
                              _showMonthPicker(context, scanProvider);
                            },
                          ),
                          scanProvider.data!.data.results.isEmpty
                              ? Text("No Data Found")
                              : SizedBox(),
                          ...scanProvider.data?.data.results.map((record) {
                                final scanIn = parseDateTime(
                                    getSafeString(value: record['check_in']));
                                final scanOut = parseDateTime(
                                    getSafeString(value: record['check_out']));
                                return _buildDailyCard(
                                    date: formatDate(
                                        getSafeString(value: record['date'])),
                                    hours: convertToHoursMinutes(
                                        value: record['working_hour']),
                                    loginTime:
                                        getSafeString(value: scanIn['time']),
                                    logoutTime:
                                        getSafeString(value: scanOut['time']),
                                    percent: clampToZeroOne(getSafeDouble(
                                        value: record['percentage'])));
                              }).toList() ??
                              [],
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      }),
    );
  }

  void _showMonthPicker(BuildContext context, DailyProvider provider) {
    MonthPickerWidget.show(
      context,
      initialSelectedMonth: _selectedMonth,
      onMonthSelected: (startDate, endDate) {
        setState(() {
          _selectedMonth =
              startDate; // Using startDate as the selected month reference
          _startDate = startDate;
          _endDate = endDate;
        });
        provider.getHome(
            startDate: startDate.toIso8601String().split('T')[0],
            endDate: endDate.toIso8601String().split('T')[0]);
      },
    );
  }

  Widget _buildDailyCard({
    required String date,
    required String loginTime,
    required String logoutTime,
    required String hours,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        children: [
          Container(
            width: 8.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        width: 200.0,
                        lineHeight: 8.0,
                        percent: percent,
                        backgroundColor: Colors.grey[300],
                        progressColor: Colors.blue[700],
                        barRadius: const Radius.circular(4.0),
                        animation: true,
                        animationDuration: 500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.login, color: Colors.blue[700], size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      loginTime,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Icon(Icons.logout, color: Colors.blue[700], size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      logoutTime,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const SizedBox(width: 8.0),
                    Text(
                      hours,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
