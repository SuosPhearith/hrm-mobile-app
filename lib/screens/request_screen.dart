import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/date/date_chooser.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(RequestProvider provider) async {
    return await provider.getHome();
  }

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

  // @override
  // void initState() {
  //   super.initState();
  //   // Use current month as default
  //   final now = DateTime.now();
  //   sselectedMonth = now;

  //   // Set start date to first day of current month
  //   _startDate = DateTime(now.year, now.month, 1);
  //   // Set end date to last day of current month
  //   _endDate = DateTime(now.year, now.month + 1, 0);

  //   selectedYear = now.year;
  //   selectedMonth = now.month - 1;
  // }

  int getLastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RequestProvider, SettingProvider>(
      builder: (context, requestProvider, settingProvider, child) {
        final dataSetup = requestProvider.dataSetup?.data;
        return Scaffold(
          // backgroundColor: Color(0xFFF1F5F9),
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: CustomHeader(),
            // title: Text(
            //   AppLang.translate(
            //     key: 'request',
            //     lang: settingProvider.lang ?? 'kh',
            //   ),
            //   style: const TextStyle(
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black,
            //   ),
            // ),
            title: GestureDetector(
              onTap: () {
                _showMonthPicker(context, requestProvider);
               
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayMonth.isEmpty ? "ស្កេន" : "ស្កេន - $displayMonth",
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
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            actions: [
              // GestureDetector(
              //   onTap: () {
              //     _showAddRequestBottomSheet(context, dataSetup ?? {});
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //       padding: const EdgeInsets.all(6.0),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //       ),
              //       child: Icon(
              //         Icons.add,
              //         size: 28.0,
              //         color: HColors.darkgrey,
              //       ),
              //     ),
              //   ),
              // ),
              IconButton(
                  onPressed: () {
                    _showAddRequestBottomSheet(context, dataSetup ?? {});
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.blue[800],
            backgroundColor: Colors.white,
            onRefresh: () => _refreshData(requestProvider),
            child: requestProvider.isLoading
                ? const Center(child: Text('Loading...'))
                : requestProvider.requestData == null
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                              '${AppRoutes.detailRequest}/1}',
                            );
                          },
                          child: Text('Something when wrong'),
                        ),
                      )
                    : SafeArea(
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...requestProvider.requestData!.data.results.map((
                                  record,
                                ) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        '${AppRoutes.detailRequest}/${record['id']}',
                                      );
                                    },
                                    child: _buildRequestCard(
                                      id: AppLang.translate(
                                        data: record['request_category'],
                                        lang: settingProvider.lang ?? 'kh',
                                      ),
                                      status: AppLang.translate(
                                        data: record['request_status'],
                                        lang: settingProvider.lang ?? 'kh',
                                      ),
                                      dates:
                                          '${formatDate(record['start_datetime'])} ដល់ ${formatDate(record['end_datetime'])}',
                                      days: calculateDateDifference(
                                        record['start_datetime'],
                                        record['end_datetime'],
                                      ),
                                      description:
                                          '${AppLang.translate(data: record['request_type'], lang: settingProvider.lang ?? 'kh')} | ${formatStringValue(record['objective'])}',
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                    ),
          ),
        );
      },
    );
  }

  void _showMonthPicker(BuildContext context, RequestProvider provider) {
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

  void _showAddRequestBottomSheet(
    BuildContext context,
    Map<String, dynamic> dataSetup,
  ) {
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;

    // Expanded list of icons to cover more categories
    final List<IconData> icons = [
      Icons.person,
      Icons.airplanemode_on,
      Icons.home,
      Icons.car_repair,
      Icons.medical_services,
      Icons.school,
      Icons.work,
      Icons.restaurant,
      Icons.shopping_cart,
      Icons.sports,
      Icons.music_note,
      Icons.camera_alt,
      Icons.travel_explore,
      Icons.build,
      Icons.cleaning_services,
      Icons.pets,
      Icons.local_hospital,
      Icons.local_pharmacy,
      Icons.local_taxi,
      Icons.local_shipping,
      Icons.business,
      Icons.account_balance,
      Icons.security,
      Icons.support,
      Icons.help,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        final requestCategories = dataSetup['request_categories'] != null
            ? dataSetup['request_categories'] as List
            : [];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'បន្ថែមសំណើថ្មី',
                //   style: TextStyle(
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                ...requestCategories.asMap().entries.map((entry) {
                  int index = entry.key;
                  var record = entry.value;
          
                  // Use modulo to cycle through icons if there are more categories than icons
                  IconData selectedIcon = icons[index % icons.length];
          
                  return _buildBottomSheetOption(
                    icon: selectedIcon,
                    label: AppLang.translate(data: record, lang: lang ?? 'kh'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/create-request/${record['id']}');
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8, top: 8),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey),
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(icon, size: 24.0, color: HColors.darkgrey),
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: HColors.darkgrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required String id,
    required String status,
    required String dates,
    required String days,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    id,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 14,
                      // fontFamily: 'Kantumruy Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          dates,
                          style: TextStyle(
                            // color: const Color(0xFF0F172A),
                            fontSize: 12,
                            // fontFamily: 'Kantumruy Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: ShapeDecoration(
                          color: const Color(0x193B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          days,
                          style: TextStyle(
                            color: const Color(0xFF3B82F6),
                            fontSize: 10,
                            // fontFamily: 'Kantumruy Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      // color: const Color(0xFF64748B),
                      fontSize: 12,
                      // fontFamily: 'Kantumruy Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                color: const Color(0x19F59E0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFF59E0B),
                  fontSize: 10,
                  // fontFamily: 'Kantumruy Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
