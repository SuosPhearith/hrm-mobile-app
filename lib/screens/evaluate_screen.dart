import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/evaluate_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';

import 'package:provider/provider.dart';

class EvaluateScreen extends StatefulWidget {
  const EvaluateScreen({super.key});

  @override
  State<EvaluateScreen> createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(EvaluationProvider provider) async {
    return await provider.getHome();
  }

  DateTime? sselectedMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  // Variables for year picker
  int selectedYear = DateTime.now().year;
  late String displayYear;

  @override
  void initState() {
    super.initState();
    // Initialize with current year
    final now = DateTime.now();
    selectedYear = now.year;
    displayYear = selectedYear.toString();
    sselectedMonth = DateTime(selectedYear, 1, 1);
    _startDate = sselectedMonth;
    _endDate = DateTime(selectedYear, 12, 31);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EvaluationProvider(),
      child: Consumer2<EvaluationProvider, SettingProvider>(
        builder: (context, evaluationProvider, settingProvider, child) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.blue[800],
            backgroundColor: Colors.white,
            onRefresh: () => _refreshData(evaluationProvider),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: GestureDetector(
                  onTap: () {
                    _showYearPicker(context, evaluationProvider);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "ប្រចាំថ្ងៃ - $displayYear",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
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
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.sync,
                      color: HColors.darkgrey,
                      size: 28.0,
                    ),
                    onPressed: () {
                      final startDate =
                          '${selectedYear.toString().padLeft(4, '0')}-01-01';
                      final endDate =
                          '${selectedYear.toString().padLeft(4, '0')}-12-31';

                      evaluationProvider.getHome(
                        startDate: startDate,
                        endDate: endDate,
                      );
                    },
                    splashRadius: 20.0,
                  ),
                ],
                bottom: CustomHeader(),
              ),
              body: evaluationProvider.isLoading
                  ? Center(
                      child: Text("Loading..."),
                    )
                  : SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: List.generate(
                            (evaluationProvider.evaluationListData
                                    ?.data['results'] as List)
                                .length,
                            (index) {
                              final result = evaluationProvider
                                          .evaluationListData?.data['results']
                                      [index] as Map<String, dynamic>? ??
                                  {};
                              final rawPresentHour = result['present_hour'];
                              final presentHour = (rawPresentHour is double)
                                  ? rawPresentHour.toStringAsFixed(0)
                                  : rawPresentHour.toString();
                              final rawMissionHour = result['mission_hour'];
                              final missionHour = (rawMissionHour is double)
                                  ? rawMissionHour.toStringAsFixed(0)
                                  : rawMissionHour.toString();
                              final absenceHour =
                                  (result['absence_hour'] ?? 0).toString();
                              final date = (result['date'] ?? '-').toString();
                              final finalGrade =
                                  (result['final_grade'] ?? '-').toString();

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildevaluationCard(
                                  presentHour: presentHour,
                                  absenceHour: absenceHour,
                                  missionHour: missionHour,
                                  date: date,
                                  finalGrade: finalGrade,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _showYearPicker(BuildContext context, EvaluationProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => YearPickerContent(
        initialYear: selectedYear,
        onConfirm: (year) {
          final startDate = '${year.toString().padLeft(4, '0')}-01-01';
          final endDate = '${year.toString().padLeft(4, '0')}-12-31';

          setState(() {
            selectedYear = year;
            displayYear = year.toString();
            sselectedMonth = DateTime(year, 1, 1);
            _startDate = DateTime(year, 1, 1);
            _endDate = DateTime(year, 12, 31);
          });

          provider.getHome(
            startDate: startDate,
            endDate: endDate,
          );
        },
      ),
    );
  }
}

// Updated YearPickerContent widget with YearPicker and no dividers
class YearPickerContent extends StatefulWidget {
  final int initialYear;
  final Function(int year) onConfirm;

  const YearPickerContent({
    super.key,
    required this.initialYear,
    required this.onConfirm,
  });

  @override
  _YearPickerContentState createState() => _YearPickerContentState();
}

class _YearPickerContentState extends State<YearPickerContent> {
  late int tempYear;

  @override
  void initState() {
    super.initState();
    tempYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ជ្រើសរើសឆ្នាំ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Kantumruy Pro',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: DividerThemeData(
                  color: HColors.darkgrey.withOpacity(0.1), // Hide dividers
                ),
              ),
              child: YearPicker(
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                selectedDate: DateTime(tempYear),
                onChanged: (DateTime dateTime) {
                  setState(() {
                    tempYear = dateTime.year;
                  });
                },
              ),
            ),
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
                  child: const Text(
                    "បិត",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HColors.blue,
                  ),
                  onPressed: () {
                    widget.onConfirm(tempYear);
                    Navigator.pop(context);
                  },
                  child: const Text(
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
}

// Existing _buildevaluationCard and _buildStatusItem (unchanged)
Widget _buildevaluationCard({
  required String presentHour,
  required String absenceHour,
  required String missionHour,
  required String date,
  required String finalGrade,
}) {
  return Stack(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatusItem(
                      icon: Icons.person,
                      color: Colors.green,
                      bgColor: Colors.green.withOpacity(0.2),
                      value: presentHour,
                    ),
                    const SizedBox(width: 16),
                    _buildStatusItem(
                      icon: Icons.person_off,
                      color: Colors.red,
                      bgColor: Colors.red.withOpacity(0.2),
                      value: absenceHour,
                    ),
                    const SizedBox(width: 16),
                    _buildStatusItem(
                      icon: Icons.flight,
                      color: Colors.grey,
                      bgColor: Colors.grey.withOpacity(0.2),
                      value: missionHour,
                    ),
                  ],
                )
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.yellow, width: 1),
                color: Colors.yellow.withOpacity(0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                finalGrade,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber,
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

Widget _buildStatusItem({
  required IconData icon,
  required Color color,
  required Color bgColor,
  required String value,
}) {
  return Row(
    children: [
      Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
      const SizedBox(width: 8),
      Text(
        '$value h',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
