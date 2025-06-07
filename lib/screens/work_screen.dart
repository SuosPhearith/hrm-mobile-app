import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/work_provider.dart';
import 'package:mobile_app/services/work_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
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

  final WorkService _service = WorkService();
  // delete medal
  void _deleteUserMedal(int id, WorkProvider provider, int userId) async {
    try {
      await _service.delete(id: id, userId: userId);
      provider.getHome();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLang.translate(lang: 'kh', key: 'deleted success'))),
        );

        // context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('មានបញ្ហាក្នុងការលុប: $e')),
        );
      }
    }
  }

  // delete work history
  void _deleteWorkHistory(int id, WorkProvider provider, int userId) async {
    try {
      await _service.deleteWorkHistory(id: id, userId: userId);
      provider.getHome();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLang.translate(lang: 'kh', key: 'deleted success'))),
        );

        // context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('មានបញ្ហាក្នុងការលុប: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WorkProvider, SettingProvider>(
      builder: (context, provider, settingProvider, child) {
        final user = provider.data?.data['user'];
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(AppLang.translate(
                key: 'work', lang: settingProvider.lang ?? 'kh')),
            centerTitle: true,
            bottom: CustomHeader(),
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
                                  '/update-user-work/${user['id']}/${user['user_work']['id']}'),
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
                                value: user?['user_work']['staff_card_number'],
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
                                    data: user?['user_work']['department'],
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
                                value:
                                    formatDate(user['user_work']['prakas_at'])),
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
                              context
                                  .push('/create-work-history/${user['id']}');
                            },
                          ),
                          ...(user?['user_work_history'] != null
                                  ? user['user_work_history'] as List
                                  : [])
                              .map((record) {
                            return buildProfileContainerAction1(
                              name:
                                  "${AppLang.translate(data: record['organization'], lang: settingProvider.lang ?? 'kh')} - ${AppLang.translate(data: record['department'], lang: settingProvider.lang ?? 'kh')}",
                              descriptionItems: [
                                {
                                  'icon': Icons.apartment_outlined,
                                  'description': AppLang.translate(
                                      data: record['office'],
                                      lang: settingProvider.lang ?? 'kh'),
                                },
                                {
                                  'icon': Icons.person_outline,
                                  'description': AppLang.translate(
                                      data: record['position'],
                                      lang: settingProvider.lang ?? 'kh'),
                                },
                                {
                                  'icon': Icons.star_outline,
                                  'description':
                                      "ឋានៈស្មើ ${AppLang.translate(data: record['rank_position'], lang: settingProvider.lang ?? 'kh')}",
                                },
                                {
                                  'icon': Icons.calendar_month_outlined,
                                  'description':
                                      "${formatDate(record['start_working_at'])} | ${formatDate(record['stop_working_at'])}",
                                },
                              ],
                              icon: Icons.work_outline,
                              onDelete: () {
                                _deleteWorkHistory(
                                    record['id'], provider, user['id']);
                              },
                              onUpdated: () {
                                context.push(
                                    '/update-work-history/${user['id']}/${record['id']}');
                              },
                            );
                          }),

                          //Medal
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
                              context.push('/create-user-medal/${user['id']}');
                            },
                          ),
                          ...(user?['user_medals'] != null
                                  ? user['user_medals'] as List
                                  : [])
                              .map((record) {
                            // Check if note_ is null or empty
                            String noteText = record['note_'] != null &&
                                    record['note_'].toString().isNotEmpty
                                ? getSafeString(value: record['note_'])
                                : '';

                            return buildProfileContainerAction1(
                              name: AppLang.translate(
                                  data: record['medals'],
                                  lang: settingProvider.lang ?? 'kh'),
                              descriptionItems: [
                                {
                                  'icon': Icons.military_tech_outlined,
                                  'description':
                                      "${AppLang.translate(data: record['medal_types'], lang: settingProvider.lang ?? 'kh')}${noteText.isNotEmpty ? ' | $noteText' : ''}",
                                },
                                {
                                  'icon': Icons.calendar_today_outlined,
                                  'description': formatDate(record['given_at']),
                                },
                              ],
                              icon: Icons.military_tech_outlined,
                              onDelete: () {
                                _deleteUserMedal(
                                    record['id'], provider, user['id']);
                              },
                              onUpdated: () {
                                context.push(
                                    '/update-user-medal/${user['id']}/${record['id']}');
                              },
                            );
                          }),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      ),
                    )),
          ),
        );
      },
    );
  }

  Widget buildIconTextContainer({
    required String text,
    IconData icon = Icons.group,
    Color textColor = Colors.blueAccent,
    Color iconColor = HColors.darkgrey,
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
              backgroundColor: avatarColor ?? HColors.darkgrey.withOpacity(0.1),
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
          Icon(Icons.info_outline, size: 20.0, color: HColors.darkgrey),
          Spacer(),
          // Only show edit icon if onEditTap is provided
          if (onEditTap != null)
            GestureDetector(
              onTap: onEditTap,
              child: Icon(Icons.edit, size: 20.0, color: HColors.darkgrey),
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
            backgroundColor: HColors.darkgrey.withOpacity(0.1),
            child: Icon(icon, size: 25.0, color: HColors.darkgrey),
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
                  style: TextStyle(fontSize: 14.0, color: HColors.darkgrey),
                  softWrap: true, // Allow text to wrap to multiple lines
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildProfileContainerAction({
  //   required String name,
  //   required String description,
  //   required VoidCallback? onDelete,
  //   required VoidCallback? onUpdated,
  //   IconData icon = Icons.person,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.only(bottom: 16.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CircleAvatar(
  //           radius: 25.0,
  //           backgroundColor: Colors.grey[300],
  //           child: Icon(icon, size: 25.0, color: Colors.grey),
  //         ),
  //         SizedBox(width: 8.0),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(name,
  //                   style: TextStyle(fontSize: 16.0, color: Colors.black87),
  //                   softWrap: true),
  //               SizedBox(height: 2.0),
  //               Text(description,
  //                   style: TextStyle(fontSize: 14.0, color: Colors.grey),
  //                   softWrap: true),
  //             ],
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.edit, size: 20.0, color: Colors.grey),
  //           onPressed: () {
  //             _showBottomSheet(context, onDelete!, onUpdated!);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildProfileContainerAction1({
    required String name,
    required List<Map<String, dynamic>> descriptionItems,
    required VoidCallback? onDelete,
    required VoidCallback? onUpdated,
    IconData icon = Icons.person,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: HColors.darkgrey.withOpacity(0.1),
            child: Icon(icon, size: 25.0, color: HColors.darkgrey),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0),
                  softWrap: true,
                ),
                SizedBox(height: 2.0),
                ...descriptionItems.map((item) => Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 14.0,
                          color: HColors.darkgrey,
                        ),
                        SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            item['description'] as String,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HColors.darkgrey,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20.0, color: HColors.darkgrey),
            onPressed: () {
              _showBottomSheet(context, onDelete!, onUpdated!);
            },
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, VoidCallback onDelete, VoidCallback onUpdated) {
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomSheetOption(
                icon: Icons.edit,
                label: AppLang.translate(key: 'update', lang: lang ?? 'kh'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet first
                  onUpdated(); // Then execute the callback
                },
              ),
              _buildBottomSheetOption(
                icon: Icons.delete,
                label: AppLang.translate(key: 'delete', lang: lang ?? 'kh'),
                colors: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  showConfirmDialog(
                    context,
                    AppLang.translate(
                        lang: lang ?? 'kh', key: 'Confirm Delete'),
                    '${AppLang.translate(lang: lang ?? 'kh', key: 'Are you sure to delete')}?',
                    DialogType.primary,
                    onDelete,
                  );
                },
              ),
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
    Color? colors,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: EdgeInsets.only(bottom: 8),
        // decoration: BoxDecoration(
        //   // border: Border.all(color: Colors.grey),
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(icon, size: 24.0, color: colors ?? HColors.darkgrey),
            ),
            const SizedBox(width: 12.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                // color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
