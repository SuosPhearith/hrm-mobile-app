import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/app_lang.dart';

import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final storage = FlutterSecureStorage();
  // String? name, email;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            AppLang.translate(
              lang: lang ?? 'kh',
              key: 'settings',
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.info_outline,
                color: HColors.darkgrey,
              ),
            )
          ],
          bottom: CustomHeader(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    // margin: EdgeInsets.only(
                    //     bottom: isLastItem
                    //         ? 0
                    //         : 12), // Add spacing except for last item
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
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: authProvider.profile?.data['user']
                                        ['avatar'] !=
                                    null
                                ? NetworkImage(
                                    '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                                  )
                                : null,
                            child: authProvider.profile?.data['user']['avatar'] ==
                                    null
                                ? const Icon(Icons.person,
                                    size: 30.0, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${getSafeString(safeValue: '...', value: authProvider.profile?.data['user']?['name_kh'])} (${getSafeString(safeValue: '...', value: authProvider.profile?.data['user']?['name_en'])})',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  AppLang.translate(
                                      lang: lang ?? 'kh',
                                      data: authProvider.profile?.data['user']
                                          ?['user_work']?['department']),
                                  style: TextStyle(
                                      fontSize: 12, color: HColors.darkgrey),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  // spacing: 8,
                                  // runSpacing: 4,
                                  children: [
                                    Icon(
                                      Icons.phone_android_sharp,
                                      size: 16,
                                      color: HColors.darkgrey,
                                    ),
                                    Text(
                                      '${getSafeString(value: authProvider.profile?.data['user']?['phone_number'])} | ',
                                      style: TextStyle(
                                          fontSize: 12, color: HColors.darkgrey),
                                    ),
                                    Icon(
                                      Icons.email_outlined,
                                      size: 16,
                                      color: HColors.darkgrey,
                                    ),
                                    Text(
                                      getSafeString(
                                          value: authProvider
                                              .profile?.data['user']?['email']),
                                      style: TextStyle(
                                          fontSize: 12, color: HColors.darkgrey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'គណនីត្រូវបានបង្កើតឡើងនៅថ្ងៃទី 25 ខែកុម្ភៈ ឆ្នាំ 2025',
                        style: TextStyle(fontSize: 12, color: HColors.darkgrey),
                      )
                    ],
                  ),
                ),
                // Profile Actions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: HColors.darkgrey.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        ProfileActionItem(
                          icon: Icons.credit_card,
                          text: 'ព័ត៌មានលម្អិត និងនាមប័ណ្ណ',
                          trailingText: '1 ថ្ងៃ',
                          onTap: () {},
                        ),
                        ProfileActionItem(
                          icon: Icons.shield_outlined,
                          text: 'ពាក្យសម្ងាត់ និងសុវត្ថិភាព',
                          trailingIcon: Icons.check_circle,
                          isVerified: true,
                          onTap: () {},
                        ),
                        ProfileActionItem(
                          icon: Icons.translate,
                          text: 'ភាសា',
                          flag:
                              Provider.of<SettingProvider>(context, listen: true)
                                          .lang ==
                                      'kh'
                                  ? '🇰🇭'
                                  : '🇺🇸',
                          onTap: () {
                            _showSelectLanguageBottomSheet(context);
                          },
                        ),
                        ProfileActionItem(
                          icon: Icons.notifications_active,
                          text: 'ការជូនដំណឹង',
                          // trailingText: '9.0.0',
                          onTap: () {
                            // context.push(AppRoutes.selectLanguage);
                          },
                        ),
                        ProfileActionItem(
                          icon: Icons.grid_view_outlined,
                          text: 'កម្មវិធីឌីជីថល',
                          onTap: () {
                            // context.push(AppRoutes.selectLanguage);
                          },
                        ),
                        ProfileActionItem(
                          icon: Icons.info_outline,
                          text: 'អំពីកម្មវិធី',
                          trailingText: 'ជំនាន់ 1.0.0',
                          onTap: () {
                            // context.push(AppRoutes.selectLanguage);
                          },
                        ),
                        ProfileActionItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          onTap: () {
                            showConfirmDialog(
                              context,
                              "បញ្ជាក់ការចាកចេញ",
                              "តើអ្នកពិតជាប្រាកដចង់ចាកចេញមែនឬទេ?",
                              DialogType.primary,
                              () async {
                                await authProvider.handleLogout();
                                final FlutterSecureStorage storage =
                                    FlutterSecureStorage();
                                await storage.delete(key: 'checkIn');
                              },
                            );
                          },
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? trailingText;
  final IconData? trailingIcon;
  final bool isVerified;
  final String? flag;
  final VoidCallback onTap;
  final bool isLast;

  const ProfileActionItem({
    super.key,
    required this.icon,
    required this.text,
    this.trailingText,
    this.trailingIcon,
    this.isVerified = false,
    this.flag,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(icon, size: 24, color: HColors.darkgrey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (flag != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      flag!,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                if (trailingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Icon(
                      trailingIcon,
                      size: 16,
                      color: isVerified ? Colors.green : HColors.darkgrey,
                    ),
                  ),
                if (trailingText != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      trailingText!,
                      style: TextStyle(fontSize: 14, color: HColors.darkgrey),
                    ),
                  ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: HColors.darkgrey.withOpacity(0.1)),
        ],
      ),
    );
  }
}

void _showSelectLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomSheetOption(
                label: '🇺🇸 English',
                onTap: () {
                  Provider.of<SettingProvider>(context, listen: false)
                      .handleSetLanguage('en');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16.0),
              _buildBottomSheetOption(
                label: '🇰🇭 ភាសាខ្មែរ',
                onTap: () {
                  Provider.of<SettingProvider>(context, listen: false)
                      .handleSetLanguage('kh');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildBottomSheetOption({
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
