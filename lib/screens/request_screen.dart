import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RequestProvider(),
      child: Consumer2<RequestProvider, SettingProvider>(
        builder: (context, requestProvider, settingProvider, child) {
          final dataSetup = requestProvider.dataSetup?.data;
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(
                AppLang.translate(
                  key: 'request',
                  lang: settingProvider.lang ?? 'kh',
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {
                    _showAddRequestBottomSheet(context, dataSetup ?? {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 28.0,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
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
                      ? Center(child: Text('Something when wrong'))
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...requestProvider.requestData!.data.results
                                    .map((
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
          );
        },
      ),
    );
  }

  void _showAddRequestBottomSheet(
    BuildContext context,
    Map<String, dynamic> dataSetup,
  ) {
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'បន្ថែមសំណើថ្មី',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 16.0),
              ...(dataSetup['request_categories'] != null
                      ? dataSetup['request_categories'] as List
                      : [])
                  .map((record) {
                return _buildBottomSheetOption(
                  icon: Icons.account_circle,
                  label: AppLang.translate(data: record, lang: lang ?? 'kh'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/create-request/${record['id']}');
                  },
                );
              }),
            ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(icon, size: 24.0, color: Colors.grey),
            ),
            const SizedBox(width: 12.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
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
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                dates,
                style: TextStyle(fontSize: 14.0, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  days,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            description,
            style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
