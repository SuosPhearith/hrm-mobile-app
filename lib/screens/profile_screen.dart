import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = FlutterSecureStorage();
  String? name, email;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    try {
      final String? loadedName = await storage.read(key: 'username');
      final String? loadedEmail = await storage.read(key: 'email');
      if (!mounted) return;
      setState(() {
        name = loadedName ?? '';
        email = loadedEmail ?? '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        name = '';
        email = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'គណនី',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // Replace with your primary color if needed.
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Row(
                      children: [
                        // Profile Image Container
                        // Container(
                        //   width: 36,
                        //   height: 36,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: Colors.grey[200],
                        //   ),
                        //   child: ClipOval(
                        //       child: Icon(
                        //     Icons.person,
                        //     size: 48,
                        //   )),
                        // ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: HColors.darkgrey.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: HColors.darkgrey,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 8),
                            Text(
                              name ?? 'Guest',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.white,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email ?? 'Unknown Email',
                              style: const TextStyle(
                                fontSize: 12,
                                // color: Colors.white,
                              ),
                            ),
                          ],
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
                          context.push(AppRoutes.selectLanguage);
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
  final VoidCallback? onTap;
  final bool isLast; // New parameter

  const ProfileActionItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.isLast = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: isLast
              ? null
              :  Border(
                  bottom: BorderSide(
                    color:HColors.darkgrey,
                    width: 0.1,
                  ),
                ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: HColors.darkgrey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: HColors.darkgrey,
            ),
          ],
        ),
      ),
    );
  }
}
