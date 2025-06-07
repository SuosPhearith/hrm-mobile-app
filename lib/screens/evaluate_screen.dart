import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/evaluate_provider.dart';
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
                  title: Text(
                    'វាយតម្លៃ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  centerTitle: true,
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
                                      finalGrade: finalGrade),
                                );
                              },
                            ),
                          ),
                        ),
                      )),
          );
        }));
  }
}

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
            // Left Column
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

            // Grade Circle
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

      // // Subtle decorative image at bottom right
      // Positioned(
      //   bottom: 5,
      //   right: -5,
      //   child: Image.asset(
      //     'lib/assets/images/f.png',
      //     width: 25,
      //     height: 25,
      //     fit: BoxFit.fill,
      //   ),
      // ),
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
