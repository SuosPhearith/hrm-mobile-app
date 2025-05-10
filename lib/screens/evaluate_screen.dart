import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/evaluate_provider.dart';
import 'package:provider/provider.dart';

class EvaluateScreen extends StatefulWidget {
  const EvaluateScreen({super.key});

  @override
  State<EvaluateScreen> createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(EvaluateProvider provider) async {
    return await provider.getHome();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EvaluateProvider(),
        child: Consumer2<EvaluateProvider, SettingProvider>(
            builder: (context, evaluateProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text('Evaluate'),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(evaluateProvider),
              child: evaluateProvider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildDaySummary(),
                      ),
                    ),
            ),
          );
        }));
  }
}

Widget buildDaySummary() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1, color: Colors.grey)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left section: "Day" text and icon-hour pairs
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ថ្ងៃ', // Khmer for "Day"
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Green person icon with 130h
                const Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '130 h',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Red warning icon with 16h
                const Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '16 h',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Blue airplane icon with 10h
                const Row(
                  children: [
                    Icon(
                      Icons.airplanemode_active,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '10 h',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Right section: Circular "B" button
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.amberAccent,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'B',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
