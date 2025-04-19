import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/about_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AboutProvider()),
      ],
      child: Consumer2<AboutProvider, SettingProvider>(
        builder: (context, aboutProvider, settingProvider, child) {
          final lang = settingProvider.lang;
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                AppLang.translate(key: 'about_system', lang: lang ?? 'kh'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: aboutProvider.isLoading
                ? Skeleton()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                              context,
                              AppLang.translate(
                                  key: 'about_rule', lang: lang ?? 'kh'),
                              Icons.edit_document),
                          const SizedBox(height: 12),
                          _buildInfoTile(
                            context: context,
                            icon: Icons.access_time,
                            title:
                                '${convertNumberToString(aboutProvider.aboutListData?.data['attendent_rule'][0]['working_hour_per_day'])} ${AppLang.translate(key: 'about_hours', lang: lang ?? 'kh')} / ${AppLang.translate(key: 'about_day', lang: lang ?? 'kh')}',
                            subtitle: AppLang.translate(
                                key: 'about_working_hours', lang: lang ?? 'kh'),
                          ),
                          _buildInfoTile(
                            context: context,
                            icon: Icons.calendar_month,
                            title:
                                '${convertNumberToString(aboutProvider.aboutListData?.data['attendent_rule'][0]['working_day_per_week'])} ${AppLang.translate(key: 'about_day', lang: lang ?? 'kh')} / ${AppLang.translate(key: 'about_week', lang: lang ?? 'kh')}',
                            subtitle: AppLang.translate(
                                key: 'about_number_of_days',
                                lang: lang ?? 'kh'),
                          ),
                          _buildInfoTile(
                            context: context,
                            icon: Icons.av_timer,
                            title:
                                '${convertNumberToString(aboutProvider.aboutListData?.data['attendent_rule'][0]['working_hour_per_week'])} ${AppLang.translate(key: 'about_hours', lang: lang ?? 'kh')} / ${AppLang.translate(key: 'about_week', lang: lang ?? 'kh')}',
                            subtitle: AppLang.translate(
                                key: 'about_total_hours', lang: lang ?? 'kh'),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionHeader(
                              context,
                              AppLang.translate(
                                  key: 'about_daily_scan', lang: lang ?? 'kh'),
                              Icons.face),
                          const SizedBox(height: 12),
                          _buildInfoTile(
                            context: context,
                            icon: Icons.login,
                            title: formatTimeTo12Hour(aboutProvider
                                .aboutListData
                                ?.data['attendent_rule'][0]['check_in']),
                            subtitle: AppLang.translate(
                                key: 'about_scan_in', lang: lang ?? 'kh'),
                          ),
                          _buildInfoTile(
                            context: context,
                            icon: Icons.logout,
                            title: formatTimeTo12Hour(aboutProvider
                                .aboutListData
                                ?.data['attendent_rule'][0]['check_out']),
                            subtitle: AppLang.translate(
                                key: 'about_scan_out', lang: lang ?? 'kh'),
                          ),
                          _buildInfoTile(
                            context: context,
                            icon: Icons.message_outlined,
                            title: AppLang.translate(
                                key: 'about_lunch_break', lang: lang ?? 'kh'),
                            subtitle: AppLang.translate(
                                key: 'about_note', lang: lang ?? 'kh'),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionHeader(
                              context,
                              AppLang.translate(
                                  key: 'about_face_scanner',
                                  lang: lang ?? 'kh'),
                              Icons.face),
                          const SizedBox(height: 12),
                          ...aboutProvider
                                  .aboutListData?.data['terminal_devices']
                                  .map((record) {
                                return _buildScannerTile(
                                  context: context,
                                  title: record['name'],
                                  subtitle:
                                      '${record['group']} | ${AppLang.translate(data: record['direction'], lang: lang ?? 'kh')}',
                                  status: AppLang.translate(
                                      data: record['health_check_status'],
                                      lang: lang ?? 'kh'),
                                  count:
                                      '${record['count']} ${AppLang.translate(key: 'about_day', lang: lang ?? 'kh')}',
                                );
                              }).toList() ??
                              [],
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String status,
    required String count,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
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
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.face,
                      size: 24.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[200]!],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                count,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
