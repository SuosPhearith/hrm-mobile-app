// import 'package:flutter/material.dart';
// import 'package:mobile_app/app_lang.dart';
// import 'package:mobile_app/providers/global/setting_provider.dart';
// import 'package:mobile_app/providers/local/scan_provider.dart';
// import 'package:mobile_app/utils/help_util.dart';
// import 'package:mobile_app/widgets/date_range_selector.dart';
// import 'package:mobile_app/widgets/month_picker_widget.dart';
// import 'package:provider/provider.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});

//   @override
//   ScanScreenState createState() => ScanScreenState();
// }

// class ScanScreenState extends State<ScanScreen> {
//   DateTime? _selectedMonth;
//   DateTime? _startDate;
//   DateTime? _endDate;

//   @override
//   void initState() {
//     super.initState();
//     // Use current month as default
//     final now = DateTime.now();
//     _selectedMonth = now;

//     // Set start date to first day of current month
//     _startDate = DateTime(now.year, now.month, 1);
//     // Set end date to last day of current month
//     _endDate = DateTime(now.year, now.month + 1, 0);
//   }

//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();
//   Future<void> _refreshData(ScanProvider provider) async {
//     return await provider.getHome(
//         startDate: _startDate?.toIso8601String().split('T')[0],
//         endDate: _endDate?.toIso8601String().split('T')[0]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ScanProvider(
//           startDate: _startDate?.toIso8601String().split('T')[0],
//           endDate: _endDate?.toIso8601String().split('T')[0]),
//       child: Consumer2<ScanProvider, SettingProvider>(
//           builder: (context, scanProvider, settingProvider, child) {
//         return Scaffold(
//           backgroundColor: Color(0xFFF1F5F9),
//           appBar: AppBar(
//             title: GestureDetector(
//               onTap: () {
//                 _showMonthPicker(context, scanProvider);
//               },
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'ស្កេន',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             centerTitle: true,
//             backgroundColor: Colors.white,
//             iconTheme: const IconThemeData(
//               color: Colors.black,
//             ),
//             elevation: 0,
//             actions: [
//               IconButton(
//                 icon: const Icon(
//                   Icons.date_range,
//                   color: Colors.black,
//                   size: 28.0,
//                 ),
//                 onPressed: () {
//                   _showMonthPicker(context, scanProvider);
//                 },
//                 splashRadius: 20.0,
//               ),
//             ],
//           ),
//           body: RefreshIndicator(
//             key: _refreshIndicatorKey,
//             color: Colors.blue[800],
//             backgroundColor: Colors.white,
//             onRefresh: () => _refreshData(scanProvider),
//             child: scanProvider.isLoading
//                 ? Center(child: Text('Loading...'))
//                 : scanProvider.data == null
//                     ? Center(child: Text('Something went wrong'))
//                     : SingleChildScrollView(
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               // Display selected date range
//                               DateRangeSelector(
//                                 startDate: _startDate,
//                                 endDate: _endDate,
//                                 onTap: () {
//                                   _showMonthPicker(context, scanProvider);
//                                 },
//                               ),
//                               scanProvider.data!.data.results.isEmpty
//                                   ? Text("No Data Found")
//                                   : SizedBox(),
//                               ...scanProvider.data?.data.results.map((record) {
//                                     final result = parseDateTime(getSafeString(
//                                         value: record['datetime']));
//                                     return _buildScanCard(
//                                       type: getSafeString(
//                                         value: AppLang.translate(
//                                             data: record['terminal_device']
//                                                 ['direction'],
//                                             lang: settingProvider.lang ?? 'kh'),
//                                       ),
//                                       location:
//                                           '${getSafeString(value: record['terminal_device']['name'])} | ${getSafeString(value: record['terminal_device']['group'])}',
//                                       time:
//                                           getSafeString(value: result['time']),
//                                       date:
//                                           getSafeString(value: result['date']),
//                                       icon: Icons.logout,
//                                     );
//                                   }).toList() ??
//                                   [],
//                               SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.1),
//                             ],
//                           ),
//                         ),
//                       ),
//           ),
//         );
//       }),
//     );
//   }

//   void _showMonthPicker(BuildContext context, ScanProvider provider) {
//     MonthPickerWidget.show(
//       context,
//       initialSelectedMonth: _selectedMonth,
//       onMonthSelected: (startDate, endDate) {
//         setState(() {
//           _selectedMonth =
//               startDate; // Using startDate as the selected month reference
//           _startDate = startDate;
//           _endDate = endDate;
//         });
//         provider.getHome(
//             startDate: startDate.toIso8601String().split('T')[0],
//             endDate: endDate.toIso8601String().split('T')[0]);
//       },
//     );
//   }

//   Widget _buildScanCard({
//     required String type,
//     required String location,
//     required String time,
//     required String date,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       clipBehavior: Clip.antiAlias,
//       decoration: ShapeDecoration(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(
//             width: 1,
//             color: Color(0xFFCBD5E1),
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 Container(
//                   height: 40.0,
//                   width: 40.0,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue[100]!, Colors.blue[200]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Center(
//                     child: Icon(
//                       icon,
//                       color: Colors.blue[800],
//                       size: 24.0,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12.0),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         type,
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey.shade800,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         location,
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           color: Colors.grey.shade600,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 time,
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue[800],
//                 ),
//               ),
//               Text(
//                 date,
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/scan_provider.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/date_range_selector.dart';
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
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month - 1; // 0-based for months
  
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

  @override
  void initState() {
    super.initState();
    // Use current month as default
    final now = DateTime.now();
    sselectedMonth = now;

    // Set start date to first day of current month
    _startDate = DateTime(now.year, now.month, 1);
    // Set end date to last day of current month
    _endDate = DateTime(now.year, now.month + 1, 0);
    
    selectedYear = now.year;
    selectedMonth = now.month - 1;
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
                    'ស្កេន',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
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
                icon: Icon(
                  Icons.date_range,
                  color: HColors.darkgrey,
                  size: 28.0,
                ),
                onPressed: () {
                  _showMonthPicker(context, scanProvider);
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
                ? Center(child: Text('Loading...'))
                : scanProvider.data == null
                    ? Center(child: Text('Something went wrong'))
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
                                    final result = parseDateTime(getSafeString(
                                        value: record['datetime']));
                                    return _buildScanCard(
                                      type: getSafeString(
                                        value: AppLang.translate(
                                            data: record['terminal_device']
                                                ['direction'],
                                            lang: settingProvider.lang ?? 'kh'),
                                      ),
                                      location:
                                          '${getSafeString(value: record['terminal_device']['name'])} | ${getSafeString(value: record['terminal_device']['group'])}',
                                      time:
                                          getSafeString(value: result['time']),
                                      date:
                                          getSafeString(value: result['date']),
                                      icon: Icons.logout,
                                    );
                                  }).toList() ??
                                  [],
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                            ],
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
      final lastDay = getLastDayOfMonth(year, month + 1);

      final startDate = DateTime(year, month + 1, 1);
      final endDate = DateTime(year, month + 1, lastDay);

      setState(() {
        selectedYear = year;
        selectedMonth = month;
        sselectedMonth = startDate;
        _startDate = startDate;
        _endDate = endDate;
      });

      provider.getHome(
          startDate: startDate.toIso8601String().split('T')[0],
          endDate: endDate.toIso8601String().split('T')[0]);
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