import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/work_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:provider/provider.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(WorkProvider provider) async {
    return await provider.getHome();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkProvider(),
      child: Consumer2<WorkProvider, SettingProvider>(
        builder: (context, provider, settingProvider, child) {
          final user = provider.data?.data['user'];
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(AppLang.translate(
                  key: 'work', lang: settingProvider.lang ?? 'kh')),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(provider),
              child: provider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildContainer(
                              text: AppLang.translate(
                                  key: 'work',
                                  lang: settingProvider.lang ?? 'kh'),
                              onEditTap: () => {
                                context.push(
                                    '/update-personal-info/${user['id']}'),
                              },
                            ),

                            buildProfileContainer(
                              name: getSafeString(
                                  value: user?['user_work']['id_number']),
                              description: AppLang.translate(
                                  key: 'id_number',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.grid_3x3_sharp,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: user?['user_work']
                                      ['staff_card_number'],
                                  safeValue: 'N/A'),
                              description: AppLang.translate(
                                  key: 'staff_card_number',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.credit_card_rounded,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: formatDate(
                                      user?['user_work']['appointed_at'])),
                              description: AppLang.translate(
                                  key: 'appointed_at',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_today_outlined,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: formatDate(
                                      user?['user_work']['start_working_at'])),
                              description: AppLang.translate(
                                  key: 'start_working_at',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_month,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']['organization'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'organization',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.apartment,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']
                                          ['general_department'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'department',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.business_rounded,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']['office'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'office',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.apartment,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']['position'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'position',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.person,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']['staff_type'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'staff_type',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.person,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']['rank_position'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'rank_position',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.person,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            buildContainer(
                              text:
                                  "${AppLang.translate(key: 'framework_category', lang: settingProvider.lang ?? 'kh')} - ${AppLang.translate(key: 'skill', lang: settingProvider.lang ?? 'kh')}",
                              onEditTap: () {},
                            ),
                            // buildIconTextContainer(
                            //   text: AppLang.translate(
                            //       key: 'user_info_family_add',
                            //       lang: settingProvider.lang ?? 'kh'),
                            //   icon: Icons.group,
                            //   onEditTap: () {
                            //     context.push(
                            //         '/create-user-relative/${user['id']}');
                            //   },
                            // ),
                            SizedBox(
                              height: 12,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']
                                          ['framework_category'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'framework_category',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.star,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']
                                          ['salary_rank_group'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'salary_rank_group',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.money,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      data: user?['user_work']
                                          ['salary_rank_type'],
                                      lang: settingProvider.lang ?? 'kh')),
                              description: AppLang.translate(
                                  key: 'salary_rank_type',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.keyboard_double_arrow_up_outlined,
                            ),
                            //
                            buildProfileContainer(
                              name: getSafeString(
                                  value: formatDate(user['user_work']
                                      ['upgraded_salary_rank_at'])),
                              description: AppLang.translate(
                                  key: 'upgraded_salary_rank_at',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_today,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      data: user['user_work']
                                          ['certificate_type'])),
                              description: AppLang.translate(
                                  key: 'certificate_type',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.school_outlined,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: AppLang.translate(
                                      lang: settingProvider.lang ?? 'kh',
                                      data: user['user_work']['major'])),
                              description: AppLang.translate(
                                  key: 'major',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.school,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: formatDate(
                                      user['user_work']['graduated_at'])),
                              description: AppLang.translate(
                                  key: 'graduated_at',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_month,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: user['user_work']['prakas_number']),
                              description: AppLang.translate(
                                  key: 'prakas_number',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_month,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: formatDate(
                                      user['user_work']['prakas_at'])),
                              description: AppLang.translate(
                                  key: 'prakas_at',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_month,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: user['user_work']['note_']),
                              description: AppLang.translate(
                                  key: 'user_info_note',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_month,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            buildContainer(
                              text: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'work_experience'),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            buildIconTextContainer(
                              text: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'work_experience_add'),
                              icon: Icons.work_history,
                              onEditTap: () {
                                context.push('/create-work-history/${user['id']}');
                              },
                            ),
                            ...(user?['user_work']['user_medals'] != null
                                    ? user['user_work']['user_medals'] as List
                                    : [])
                                .map((record) {
                              return buildProfileContainer(
                                name:
                                    "${AppLang.translate(data: record['user_medals'], lang: settingProvider.lang ?? 'kh')} - ${AppLang.translate(data: record['medal_types'], lang: settingProvider.lang ?? 'kh')}",
                                description:
                                    '• ${AppLang.translate(data: record['note'], lang: settingProvider.lang ?? 'kh')} \n• ${AppLang.translate(data:record['given_at'], lang: settingProvider.lang ?? 'kh')} \n• ${AppLang.translate(data: record['major'], lang: settingProvider.lang ?? 'kh')}\n• ${AppLang.translate(data: record['education_place'], lang: settingProvider.lang ?? 'kh')}\n• ${formatDate(record['study_at'])} | ${formatDate(record['graduate_at'])}',
                                icon: Icons.person,
                              );
                            }),

                            //Language
                            buildContainer(
                              text: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'medals'),
                            ),
                            buildIconTextContainer(
                              text: AppLang.translate(
                                  key: 'medals_add',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.star,
                              onEditTap: () {
                                context.push(
                                    '/create-langauge-level/${user['id']}');
                              },
                            ),
                            ...(user?['user_work']['user_medals'] != null
                                    ? user['user_work']['user_medals'] as List
                                    : [])
                                .map((record) {
                              return buildProfileContainer(
                                name:
                                    "${AppLang.translate(data: record['user_medals'], lang: settingProvider.lang ?? 'kh')} - ${AppLang.translate(data: record['medal_types'], lang: settingProvider.lang ?? 'kh')}",
                                description:
                                    '• ${AppLang.translate(data: record['note'], lang: settingProvider.lang ?? 'kh')} \n• ${AppLang.translate(data:record['given_at'], lang: settingProvider.lang ?? 'kh')} \n• ${AppLang.translate(data: record['major'], lang: settingProvider.lang ?? 'kh')}\n• ${AppLang.translate(data: record['education_place'], lang: settingProvider.lang ?? 'kh')}\n• ${formatDate(record['study_at'])} | ${formatDate(record['graduate_at'])}',
                                icon: Icons.person,
                              );
                            }),
                            // buildProfileContainerAction(
                            //   name: 'ឃួច ទីទ្ធ (khouch tith)',
                            //   description:
                            //       '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                            //   icon: Icons.person,
                            // ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                          ],
                        ),
                      )),
            ),
          );
        },
      ),
    );
  }

  Widget buildIconTextContainer({
    required String text,
    IconData icon = Icons.group,
    Color textColor = Colors.blueGrey,
    Color iconColor = Colors.grey,
    Color? avatarColor,
    VoidCallback? onEditTap, // Made optional with nullable type
  }) {
    return GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: avatarColor ?? Colors.grey[300],
              child: Icon(icon, size: 25.0, color: iconColor),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0, color: textColor),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer({
    required String text,
    VoidCallback? onEditTap, // Made optional with nullable type
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(width: 8.0),
          Icon(Icons.info_outline, size: 20.0, color: Colors.grey),
          Spacer(),
          // Only show edit icon if onEditTap is provided
          if (onEditTap != null)
            GestureDetector(
              onTap: onEditTap,
              child: Icon(Icons.edit, size: 20.0, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget buildProfileContainer({
    required String name,
    required String description,
    IconData icon = Icons.person, // Default icon is person
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Align to top so avatar stays at top when text wraps
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey[300],
            child: Icon(icon, size: 25.0, color: Colors.grey),
          ),
          SizedBox(width: 8.0),
          Expanded(
            // Expanded to allow text to fill available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  softWrap: true, // Allow text to wrap to multiple lines
                ),
                SizedBox(
                    height: 2.0), // Small spacing between name and description
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  softWrap: true, // Allow text to wrap to multiple lines
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileContainerAction({
    required String name,
    required String description,
    IconData icon = Icons.person, // Default icon is person
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey[300],
            child: Icon(icon, size: 25.0, color: Colors.grey),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  softWrap: true,
                ),
                SizedBox(height: 2.0),
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20.0, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
