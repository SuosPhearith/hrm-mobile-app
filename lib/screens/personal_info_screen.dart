import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personal_info_provider.dart';
import 'package:mobile_app/services/personal_info_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(PersonalInfoProvider provider) async {
    return await provider.getHome();
  }

  final PersonalInfoService _service = PersonalInfoService();
  // delete relative
  void _deleteRelative(int id, PersonalInfoProvider provider) async {
    try {
      await _service.delete(id: id);
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

  //delete  education
  void _deleteEducation(int id, int userID,PersonalInfoProvider provider) async {
    try {
      await _service.deleteEducation(id: id, userId: userID);
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

  //delete  language level
  void _deleteLanuageLevel(int id, int userID,PersonalInfoProvider provider) async {
    try {
      await _service.deleteLanguageLevel(id: id, userId: userID);
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
    return ChangeNotifierProvider(
      create: (_) => PersonalInfoProvider(),
      child: Consumer2<PersonalInfoProvider, SettingProvider>(
        builder: (context, provider, settingProvider, child) {
          final user = provider.data?.data['user'];
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(AppLang.translate(
                  key: 'user_info_personal_info',
                  lang: settingProvider.lang ?? 'kh')),
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
                              text: 'រូបភាព',
                              onEditTap: () => {},
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.blue,
                                child: CircleAvatar(
                                  radius: 48.0,
                                  backgroundImage: NetworkImage(
                                      '${user?['avatar']?['file_domain']}${user?['avatar']?['uri']}'),
                                ),
                              ),
                            ),
                            buildContainer(
                              text: AppLang.translate(
                                  key: 'user_info_personal_info',
                                  lang: settingProvider.lang ?? 'kh'),
                              onEditTap: () => {
                                context.push(
                                    '/update-personal-info/${user['id']}'),
                              },
                            ),
                            buildProfileContainer(
                              name:
                                  '${AppLang.translate(data: user?['salute'], lang: settingProvider.lang ?? 'kh')} ${getSafeString(value: user?['name_kh'])}\n(${getSafeString(value: user?['name_en'])})',
                              description: AppLang.translate(
                                  key: 'user_info_name',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.person,
                            ),
                            buildProfileContainer(
                              name: AppLang.translate(
                                  data: user?['sex'],
                                  lang: settingProvider.lang ?? 'kh'),
                              description: AppLang.translate(
                                  key: 'user_info_sex',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.transgender,
                            ),
                            buildProfileContainer(
                              name: getSafeString(value: user?['phone_number']),
                              description: AppLang.translate(
                                  key: 'user_info_phone',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.phone_iphone,
                            ),
                            buildProfileContainer(
                              name: getSafeString(value: user?['email']),
                              description: AppLang.translate(
                                  key: 'user_info_email',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.email,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: user?['identity_card_number']),
                              description: AppLang.translate(
                                  key: 'user_info_card_id',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.fingerprint,
                            ),
                            buildProfileContainer(
                              name: getSafeString(
                                  value: formatDate(user?['dob'])),
                              description: AppLang.translate(
                                  key: 'user_info_date_of_birth',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.calendar_today,
                            ),
                            buildProfileContainer(
                              name:
                                  '${AppLang.translate(data: user?['village'], lang: settingProvider.lang ?? 'kh')} ${AppLang.translate(data: user?['commune'], lang: settingProvider.lang ?? 'kh')} ${AppLang.translate(data: user?['district'], lang: settingProvider.lang ?? 'kh')} ${AppLang.translate(data: user?['province'], lang: settingProvider.lang ?? 'kh')}',
                              description: AppLang.translate(
                                  key: 'user_info_place_of_birth',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.location_on,
                            ),
                            buildProfileContainer(
                              name:
                                  '${AppLang.translate(data: user?['pob_village'], lang: settingProvider.lang ?? 'kh')} ${AppLang.translate(data: user?['pob_commune'], lang: settingProvider.lang ?? 'kh')} ${AppLang.translate(data: user?['pob_district'], lang: settingProvider.lang ?? 'kh')} ${AppLang.translate(data: user?['pob_province'], lang: settingProvider.lang ?? 'kh')}',
                              description: AppLang.translate(
                                  key: 'user_info_current_address',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.location_on,
                            ),
                            buildContainer(
                              text: AppLang.translate(
                                  key: 'user_info_family',
                                  lang: settingProvider.lang ?? 'kh'),
                            ),
                            buildIconTextContainer(
                              text: AppLang.translate(
                                  key: 'user_info_family_add',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.group,
                              onEditTap: () {
                                context.push(
                                    '/create-user-relative/${user['id']}');
                              },
                            ),

                            ...(user?['relatives'] != null
                                    ? user['relatives'] as List
                                    : [])
                                .map((record) {
                              return buildProfileContainerAction(
                                name:
                                    '${getSafeString(value: record?['name_kh'])} (${getSafeString(value: record?['name_en'])})',
                                description:
                                    '${formatDate(record['dob'])} • ${getSafeString(value: record?['job'])} • ${getSafeString(value: record?['work_place'])}',
                                icon: Icons.person,
                                onDelete: () =>
                                    _deleteRelative(record['id'], provider),
                                onUpdated: () {
                                  // Navigator.pop(context);
                                  context
                                      .push('/update-relative/${user['id']}/${record['id']}');
                                },
                              );
                            }),
                            buildContainer(
                              text: 'ការសិក្សា',
                            ),
                            buildIconTextContainer(
                              text: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_education_add'),
                              icon: Icons.group,
                              onEditTap: () {
                                context.push('/create-education/${user['id']}');
                              },
                            ),
                            ...(user?['user_educations'] != null
                                    ? user['user_educations'] as List
                                    : [])
                                .map((record) {
                              return buildProfileContainerAction(
                                name:
                                    "${AppLang.translate(data: record['education_type'], lang: settingProvider.lang ?? 'kh')} - ${AppLang.translate(data: record['education_level'], lang: settingProvider.lang ?? 'kh')}",
                                description:
                                    '• ${AppLang.translate(data: record['school'], lang: settingProvider.lang ?? 'kh')} \n• ${AppLang.translate(data: record['education_place'], lang: settingProvider.lang ?? 'kh')} \n• ${AppLang.translate(data: record['major'], lang: settingProvider.lang ?? 'kh')}\n• ${AppLang.translate(data: record['education_place'], lang: settingProvider.lang ?? 'kh')}\n• ${formatDate(record['study_at'])} | ${formatDate(record['graduate_at'])}',
                                icon: Icons.person,
                                onDelete: () =>
                                    _deleteEducation(record['id'], user['id'],provider),
                                onUpdated: () {
                                  context
                                      .push('/update-education/${user['id']}/${record['id']}');
                                },
                              );
                            }),

                            //Language
                            buildContainer(
                              text: AppLang.translate(
                                  lang: settingProvider.lang ?? 'kh',
                                  key: 'user_info_language'),
                            ),
                            buildIconTextContainer(
                              text: AppLang.translate(
                                  key: 'user_info_language_add',
                                  lang: settingProvider.lang ?? 'kh'),
                              icon: Icons.translate,
                              onEditTap: () {
                                context.push(
                                    '/create-langauge-level/${user['id']}');
                              },
                            ),
                            ...(user?['user_languages'] != null
                                    ? user['user_languages'] as List
                                    : [])
                                .map((record) {
                              return buildProfileContainerAction(
                                name:
                                    "${AppLang.translate(data: record['language'], lang: settingProvider.lang ?? 'kh')} ",
                                description:
                                    '🗣️${AppLang.translate(data: record['speaking_level'], lang: settingProvider.lang ?? 'kh')} ✍️${AppLang.translate(data: record['writing_level'], lang: settingProvider.lang ?? 'kh')} 📖${AppLang.translate(data: record['reading_level'], lang: settingProvider.lang ?? 'kh')} 🦻${AppLang.translate(data: record['listening_level'], lang: settingProvider.lang ?? 'kh')}',
                                icon: Icons.flag,
                                onDelete: () => _deleteLanuageLevel(
                                    record['id'], user['id'],provider),
                                onUpdated: () {
                                  // context.push('');
                                  context
                                      .push('/update-langauge-level/${user['id']}/${record['id']}');
                                },
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

  // Widget buildProfileContainerAction({
  //   required String name,
  //   required String description,
  //   IconData icon = Icons.person, // Default icon is person
  //   int? iD,
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
  //               Text(
  //                 name,
  //                 style: TextStyle(fontSize: 16.0, color: Colors.black87),
  //                 softWrap: true,
  //               ),
  //               SizedBox(height: 2.0),
  //               Text(
  //                 description,
  //                 style: TextStyle(fontSize: 14.0, color: Colors.grey),
  //                 softWrap: true,
  //               ),
  //             ],
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.edit, size: 20.0, color: Colors.grey),
  //           onPressed: () {
  //             _showAddRequestBottomSheet(context, iD!);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildProfileContainerAction({
    required String name,
    required String description,
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
            backgroundColor: Colors.grey[300],
            child: Icon(icon, size: 25.0, color: Colors.grey),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                    softWrap: true),
                SizedBox(height: 2.0),
                Text(description,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    softWrap: true),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20.0, color: Colors.grey),
            onPressed: () {
              _showBottomSheet(context, onDelete!, onUpdated!);
            },
          ),
        ],
      ),
    );
  }

  // void _showAddRequestBottomSheet(
  //   BuildContext context,
  //   int id,
  // ) {
  //   final lang = Provider.of<SettingProvider>(context, listen: false).lang;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
  //     ),
  //     backgroundColor: Colors.white,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Text(
  //             //   'បន្ថែមសំណើថ្មី',
  //             //   style: TextStyle(
  //             //     fontSize: 20.0,
  //             //     fontWeight: FontWeight.bold,
  //             //     color: Colors.blue[900],
  //             //   ),
  //             // ),
  //             // const SizedBox(height: 16.0),
  //             _buildBottomSheetOption(
  //               icon: Icons.edit,
  //               label: AppLang.translate(key: 'update', lang: lang ?? 'kh'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             _buildBottomSheetOption(
  //               icon: Icons.delete,
  //               label: AppLang.translate(key: 'delete', lang: lang ?? 'kh'),
  //               colors: Colors.red,
  //               onTap: () {
  //                 showConfirmDialog(
  //                   context,
  //                   AppLang.translate(
  //                       lang: lang ?? 'kh', key: 'Confirm Delete'),
  //                   '${AppLang.translate(lang: lang ?? 'kh', key: 'Are you sure to delete')}?',
  //                   DialogType.primary,
  //                   () {
  //                     _validateAndSubmit(id);
  //                   },
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showBottomSheet(
      BuildContext context, VoidCallback onDelete, VoidCallback onUpdated) {
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
              child: Icon(icon, size: 24.0, color: colors ?? Colors.grey),
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
}
