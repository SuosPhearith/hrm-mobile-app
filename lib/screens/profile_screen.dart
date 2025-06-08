import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/app_routes.dart';
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
          title: Text(AppLang.translate(
            lang: lang??'kh',
            key: 'settings',
          ),),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: HColors.darkgrey.withOpacity(0.2),
                    ),
                  ),
                  // child: Container(
                  //   padding: const EdgeInsets.all(16),
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //       // Replace with your primary color if needed.
                  //       borderRadius: BorderRadius.circular(12),
                  //       color: Colors.white),
                  //   child: Row(
                  //     children: [
                  //       // Profile Image Container
                  //       // Container(
                  //       //   width: 36,
                  //       //   height: 36,
                  //       //   decoration: BoxDecoration(
                  //       //     shape: BoxShape.circle,
                  //       //     color: Colors.grey[200],
                  //       //   ),
                  //       //   child: ClipOval(
                  //       //       child: Icon(
                  //       //     Icons.person,
                  //       //     size: 48,
                  //       //   )),
                  //       // ),
                  // CircleAvatar(
                  //   radius: 28,
                  //   backgroundColor: Colors.grey[300],
                  //   backgroundImage: authProvider.profile?.data['user']
                  //               ['avatar'] !=
                  //           null
                  //       ? NetworkImage(
                  //           '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                  //         )
                  //       : null,
                  //   child: authProvider.profile?.data['user']['avatar'] ==
                  //           null
                  //       ? const Icon(Icons.person,
                  //           size: 30.0, color: Colors.white)
                  //       : null,
                  // ),

                  //       SizedBox(
                  //         width: 8,
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           // const SizedBox(height: 8),

                  //           Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 AppLang.translate(
                  //                     data: authProvider.profile?.data['user'],
                  //                     lang: lang ?? 'kh'),
                  //                 style: TextStyle(
                  //                   fontSize: Theme.of(context)
                  //                       .textTheme
                  //                       .bodyLarge!
                  //                       .fontSize,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 AppLang.translate(
                  //                     data: authProvider.profile?.data['user']
                  //                         ['roles'][0]['role'],
                  //                     lang: lang ?? 'kh'),
                  //                 style: TextStyle(
                  //                   fontSize: Theme.of(context)
                  //                       .textTheme
                  //                       .bodySmall!
                  //                       .fontSize,
                  //                 ),
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //               Text(
                  //                 "${getSafeString(safeValue: 'N/A', value: authProvider.profile?.data['user']['phone_number'])} | ${getSafeString(safeValue: 'N/A', value: authProvider.profile?.data['user']['email'])}",
                  //                 style: TextStyle(
                  //                   fontSize: Theme.of(context)
                  //                       .textTheme
                  //                       .bodySmall!
                  //                       .fontSize,
                  //                 ),
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                            radius: 28,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: authProvider.profile?.data['user']
                                        ['avatar'] !=
                                    null
                                ? NetworkImage(
                                    '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                                  )
                                : null,
                            child: authProvider.profile?.data['user']
                                        ['avatar'] ==
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
                                  '${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['user_work']?['general_department'])} ',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Icon(Icons.star_border, size: 16),
                                    Text(
                                      '${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['user_work']?['staff_type'])} |',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '# ${getSafeString(value: authProvider.profile?.data['user']?['user_work']?['id_number'])} |',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Icon(Icons.phone_android_sharp, size: 16),
                                    Text(
                                      '${getSafeString(value: authProvider.profile?.data['user']?['phone_number'])} ',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
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
                        onTap: () {},
                      ),
                      ProfileActionItem(
                        icon: Icons.shield_outlined,
                        text: 'ពាក្យសម្ងាត់ និងសុវត្ថិភាព',
                        onTap: () {},
                      ),
                      ProfileActionItem(
                        icon: Icons.translate,
                        text: 'ភាសា',
                        onTap: () {
                          _showSelectLanguageBottomSheet(context);
                        },
                      ),
                      ProfileActionItem(
                        icon: Icons.notifications_active,
                        text: 'ការជូនដំណឹង',
                        onTap: () {
                          context.push(AppRoutes.selectLanguage);
                        },
                      ),
                      ProfileActionItem(
                        icon: Icons.grid_view_outlined,
                        text: 'កម្មវិធីឌីជីថល',
                        onTap: () {
                          context.push(AppRoutes.selectLanguage);
                        },
                      ),
                      ProfileActionItem(
                        icon: Icons.info_outline,
                        text: 'អំពីកម្មវិធី',
                        onTap: () {
                          context.push(AppRoutes.selectLanguage);
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
                              DialogType.primary, () async {
                            await authProvider.handleLogout();
                            final FlutterSecureStorage storage =
                                FlutterSecureStorage();
                            await storage.delete(key: 'checkIn');
                          });
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
      );
    });
  }
}

class ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isLast;

  const ProfileActionItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 24, color: HColors.darkgrey),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
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
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(height: 16.0),
            _buildBottomSheetOption(
              // icon: Icons.account_circle,
              label: '🇺🇸 English',
              onTap: () {
                Provider.of<SettingProvider>(context, listen: false).handleSetLanguage('en');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16.0),
            _buildBottomSheetOption(
              // icon: Icons.airplanemode_active_rounded,
              label: '🇰🇭 ភាសាខ្មែរ',
              onTap: () {
                Provider.of<SettingProvider>(context, listen: false).handleSetLanguage('kh');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      );
    },
  );
}

Widget _buildBottomSheetOption({
  // required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(8.0),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     shape: BoxShape.circle,
          //   ),
          //   child: Icon(icon, size: 24.0, color: Colors.blue[800]),
          // ),
          // const SizedBox(width: 12.0),
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