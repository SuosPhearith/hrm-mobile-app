import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personal_info_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
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
                              onEditTap: () => {},
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
                              );
                            }),
                            buildContainer(
                              text: 'ការសិក្សា',
                            ),
                            buildIconTextContainer(
                              text: 'បន្ថែមការសិក្សា',
                              icon: Icons.group,
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
                              );
                            }),
                            // do here

                            buildContainer(
                              text: 'កម្រិតភាសា',
                            ),
                            buildProfileContainerAction(
                              name: 'ឃួច ទីទ្ធ (khouch tith)',
                              description:
                                  '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                              icon: Icons.person,
                            ),
                            buildProfileContainerAction(
                              name: 'ឃួច ទីទ្ធ (khouch tith)',
                              description:
                                  '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                              icon: Icons.person,
                            ),
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
  }) {
    return Container(
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
