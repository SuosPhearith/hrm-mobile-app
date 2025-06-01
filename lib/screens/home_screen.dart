import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/home_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_progress_bar.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

// Main HomeScreen widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String selectedIndex = 'Pending';

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(HomeProvider provider) async {
    return await provider.getHome();
  }

  String formatDateToDDMMYY(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: Consumer3<AuthProvider, HomeProvider, SettingProvider>(
        builder: (context, authProvider, homeProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Color(0xFFF1F5F9),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(homeProvider),
              child: homeProvider.isLoading
                  ? const Skeleton()
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          UserProfileHeader(authProvider: authProvider),
                          DailyMonthlyView(
                            currentIndex: _currentIndex,
                            onPageChanged: (index) =>
                                setState(() => _currentIndex = index),
                            homeProvider: homeProvider,
                            formatDateToDDMMYY: formatDateToDDMMYY,
                          ),
                          MenuGrid(),
                          RequestSection(
                            selectedIndex: selectedIndex,
                            onTabChanged: (index) =>
                                setState(() => selectedIndex = index),
                            homeProvider: homeProvider,
                            formatDateToDDMMYY: formatDateToDDMMYY,
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

// // Widget for user profile header
// class UserProfileHeader extends StatelessWidget {
//   final AuthProvider authProvider;

//   const UserProfileHeader({super.key, required this.authProvider});

//   @override
//   Widget build(BuildContext context) {
//     final lang = Provider.of<SettingProvider>(context).lang;
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 ClipOval(
//                   child: Image.network(
//                     '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}', // Replace with actual URL
//                     width: 40.0,
//                     height: 40.0,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       width: 40.0,
//                       height: 40.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey[600],
//                       ),
//                       child: const Center(
//                         child:
//                             Icon(Icons.person, size: 30.0, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6.0),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppLang.translate(
//                             data: authProvider.profile?.data['user'],
//                             lang: lang ?? 'kh'),
//                         style: TextStyle(
//                           fontSize:
//                               Theme.of(context).textTheme.bodyLarge!.fontSize,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         AppLang.translate(
//                             data: authProvider.profile?.data['user']['roles'][0]
//                                 ['role'],
//                             lang: lang ?? 'kh'),
//                         style: TextStyle(
//                           fontSize:
//                               Theme.of(context).textTheme.bodySmall!.fontSize,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               _IconButton(icon: Icons.download, onPressed: null),
//               const SizedBox(width: 8.0),
//               _IconButton(icon: Icons.notifications, onPressed: null),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// Widget for user profile header
class UserProfileHeader extends StatelessWidget {
  final AuthProvider authProvider;

  const UserProfileHeader({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    // child: Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Flexible(
    //       child: Row(
    //         children: [
    //           Container(
    //             width: 40.0,
    //             height: 40.0,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: HColors.darkgrey.withOpacity(0.7),
    //             ),
    //             child: const Center(
    //               child: Icon(Icons.person, size: 30.0, color: Colors.white),
    //             ),
    //           ),
    //           const SizedBox(width: 6.0),
    //           Flexible(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   AppLang.translate(
    //                       data: homeProvider.name, lang: lang ?? 'kh'),
    //                   style: TextStyle(
    //                     fontSize:
    //                         Theme.of(context).textTheme.bodyLarge!.fontSize,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //                 Text(
    //                   AppLang.translate(
    //                       data: homeProvider.department, lang: lang ?? 'kh'),
    //                   style: TextStyle(
    //                     fontSize:
    //                         Theme.of(context).textTheme.bodySmall!.fontSize,
    //                   ),
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    // Row(
    //   children: [
    //     _IconButton(icon: Icons.download, onPressed: null),
    //     const SizedBox(width: 8.0),
    //     _IconButton(icon: Icons.notifications, onPressed: null),
    //   ],
    // ),
    //     ],
    //   ),
    // );
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[600],
                      ),
                      child: const Center(
                        child:
                            Icon(Icons.person, size: 30.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLang.translate(
                            data: authProvider.profile?.data['user'],
                            lang: lang ?? 'kh'),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        AppLang.translate(
                            data: authProvider.profile?.data['user']['roles'][0]
                                ['role'],
                            lang: lang ?? 'kh'),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall!.fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _IconButton(icon: Icons.download, onPressed: null),
              const SizedBox(width: 8.0),
              _IconButton(icon: Icons.notifications, onPressed: null),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget for icon button
class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _IconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HColors.darkgrey.withOpacity(0.1),
      ),
      child: Center(
        child: Icon(icon, color: HColors.darkgrey, size: 22.0),
      ),
    );
  }
}

// Widget for daily and monthly view
class DailyMonthlyView extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final HomeProvider homeProvider;
  final String Function(String) formatDateToDDMMYY;

  const DailyMonthlyView({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
    required this.homeProvider,
    required this.formatDateToDDMMYY,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 240,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: PageController(initialPage: 0),
                onPageChanged: onPageChanged,
                children: [
                  DailyView(
                    homeProvider: homeProvider,
                    formatDateToDDMMYY: formatDateToDDMMYY,
                  ),
                  MonthlyView(homeProvider: homeProvider),
                  // CardView(homeProvider: homeProvider),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: index == 0 ? 12.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == currentIndex
                        ? Colors.blue[700]
                        : Colors.grey[300],
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// Widget for daily view
class DailyView extends StatelessWidget {
  final HomeProvider homeProvider;
  final String Function(String) formatDateToDDMMYY;

  const DailyView({
    super.key,
    required this.homeProvider,
    required this.formatDateToDDMMYY,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    return Container(
      padding: const EdgeInsets.all(13.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLang.translate(key: 'home_today', lang: lang ?? 'kh'),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[900],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: ShapeDecoration(
                  color: const Color(0x0C1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '03-03-2025',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                        fontFamily: 'Kantumruy Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.calendar_today,
                        size: 16, color: const Color(0xFF64748B)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 8.0,
                percent: clampToZeroOne(double.tryParse(homeProvider
                        .scanByDayData?.data['percentage']
                        ?.toString() ??
                    '0.0')),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${convertToHoursAndMinutes(double.tryParse(homeProvider.scanByDayData?.data['working_hour']?.toString() ?? '0.0'))['hours']} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')}',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text(
                      '${convertToHoursAndMinutes(double.tryParse(homeProvider.scanByDayData?.data['working_hour']?.toString() ?? '0.0'))['minutes']} ${AppLang.translate(key: 'minute', lang: lang ?? 'kh')}',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ],
                ),
                progressColor: Colors.blue[700],
                backgroundColor: Colors.grey[200]!,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1000,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  children: [
                    CheckInOutCard(
                      isCheckIn: true,
                      time: formatTimeToHour(
                          homeProvider.scanByDayData?.data['check_in']),
                      terminal: getSafeString(
                          value: homeProvider
                                  .scanByDayData?.data['first_terminal_log']
                              ?['terminal_device']?['name']),
                      group: getSafeString(
                          value: homeProvider
                                  .scanByDayData?.data['first_terminal_log']
                              ?['terminal_device']?['group']),
                    ),
                    const SizedBox(height: 12.0),
                    CheckInOutCard(
                      isCheckIn: false,
                      time: formatTimeToHour(
                          homeProvider.scanByDayData?.data['check_out']),
                      terminal: getSafeString(
                          value: homeProvider
                                  .scanByDayData?.data['last_terminal_log']
                              ?['terminal_device']?['name']),
                      group: getSafeString(
                          value: homeProvider
                                  .scanByDayData?.data['last_terminal_log']
                              ?['terminal_device']?['group']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for check-in/check-out card
class CheckInOutCard extends StatelessWidget {
  final bool isCheckIn;
  final String? time;
  final String? terminal;
  final String? group;

  const CheckInOutCard({
    super.key,
    required this.isCheckIn,
    this.time,
    this.terminal,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(Icons.logout, size: 20.0, color: Colors.blue[800]),
          ),
          const SizedBox(width: 6.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time ?? '...',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${terminal ?? '...'} | ${group ?? '...'}',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
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
}

// Widget for monthly view
class MonthlyView extends StatelessWidget {
  final HomeProvider homeProvider;

  const MonthlyView({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    return Container(
      padding: const EdgeInsets.all(13.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLang.translate(key: 'home_monthly', lang: lang ?? 'kh'),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[900],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: ShapeDecoration(
                  color: const Color(0x0C1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '03-03-2025',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                        fontFamily: 'Kantumruy Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.calendar_today,
                        size: 16, color: const Color(0xFF64748B)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatCard(
                    icon: Icons.work_history,
                    iconColor: Colors.green[800]!,
                    value:
                        '${getHoursFromSumHour(homeProvider.scanByMonthData?.data['sum_hour'])} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')}',
                    label:
                        '${AppLang.translate(key: 'home_daily', lang: lang ?? 'kh')} ${convertToHoursAndMinutes(getSafeDouble(value: homeProvider.scanByMonthData?.data['avg_per_day'], safeValue: 0))['hours']} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')} ${convertToHoursAndMinutes(getSafeDouble(value: homeProvider.scanByMonthData?.data['avg_per_day'], safeValue: 0))['minutes']} ${AppLang.translate(key: 'minute', lang: lang ?? 'kh')}',
                  ),
                  StatIcon(
                    icon: Icons.person_off,
                    iconColor: Colors.red[800]!,
                    value:
                        '${homeProvider.scanByMonthData?.data['absence'] ?? '...'}',
                  ),
                  StatIcon(
                    icon: Icons.person_outline_sharp,
                    iconColor: Colors.orange[800]!,
                    value:
                        '${homeProvider.scanByMonthData?.data['leave'] ?? '...'}',
                  ),
                  StatIcon(
                    icon: Icons.airplanemode_on_sharp,
                    iconColor: Colors.blue[800]!,
                    value:
                        '${homeProvider.scanByMonthData?.data['mission'] ?? '...'}',
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLang.translate(
                        key: 'home_total_working_hours', lang: lang ?? 'kh'),
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                  Text(
                    '${AppLang.translate(key: 'home_grade_received', lang: lang ?? 'kh')} ${homeProvider.scanByMonthData?.data['grade'] ?? '...'}',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              // LinearPercentIndicator(
              //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
              //   lineHeight: 25.0,
              //   center: Text(
              //     "${getHoursFromSumHour(homeProvider.scanByMonthData?.data['sum_hour'])} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')} / ${homeProvider.scanByMonthData?.data['max_hour'] ?? '...'} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')}",
              //     style: TextStyle(
              //       fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              //   percent: clampToZeroOne(getSafeDouble(
              //       value: homeProvider.scanByMonthData?.data['percentage'])),
              //   backgroundColor: Colors.grey[300],
              //   progressColor: Colors.blue[400],
              //   barRadius: const Radius.circular(4.0),
              //   animation: true,
              //   animationDuration: 500,
              // ),
              CustomProgressBar(
                percent: getSafeDouble(
                    value: homeProvider.scanByMonthData?.data['percentage']),
                grade: getSafeString(
                    value: homeProvider.scanByMonthData?.data['grade']),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final HomeProvider homeProvider;

  const CardView({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFCBD5E1),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image: NetworkImage("https://placehold.co/80x80"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/56x56"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Title Section
                  Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Color(0xFFDDAD01),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ខួច គឿន',
                          style: TextStyle(
                            color: Color(0xFF002458),
                            fontSize: 16,
                            fontFamily: 'Kantumruy Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                          ),
                        ),
                        const Text(
                          'អនុប្រធានាយកដ្ឋាន | អគ្គលេខាធិការដ្ឋាន នៃ ក.អ.ក.',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 12,
                            fontFamily: 'Kantumruy Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Contact Information
                  _buildContactRow(Icons.phone, '+855 96 541 6704'),
                  const SizedBox(height: 4),
                  _buildContactRow(Icons.phone_android, '+855 96 541 6704'),
                  const SizedBox(height: 4),
                  _buildContactRow(Icons.email, 'khouch.koeun@gmail.com'),
                  const SizedBox(height: 4),
                  _buildContactRow(
                    Icons.location_on,
                    'វិមានរាជរដ្ឋាភិបាល, តីរវិថីស៊ីសុវត្ថិ, វត្តភ្នំ, ភ្នំពេញ',
                    isAddress: true,
                  ),
                ],
              ),
            ),
            // Action Button
            Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Icon(
                Icons.more_vert,
                size: 24,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text,
      {bool isAddress = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 12,
              fontFamily: 'Kantumruy Pro',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
            maxLines: isAddress ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Widget for stat card
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28.0, color: iconColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for stat icon
class StatIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;

  const StatIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 15, left: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.0, color: iconColor),
          Text(value),
        ],
      ),
    );
  }
}

// Widget for menu grid
class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;
    final menuItems = [
      {
        'icon': Icons.edit_calendar_outlined,
        'label': AppLang.translate(key: 'home_request', lang: lang ?? 'kh'),
        'route': AppRoutes.request
      },
      {
        'icon': Icons.face,
        'label': AppLang.translate(key: 'home_scan', lang: lang ?? 'kh'),
        'route': AppRoutes.scan
      },
      {
        'icon': Icons.access_time,
        'label': AppLang.translate(key: 'home_daily', lang: lang ?? 'kh'),
        'route': AppRoutes.daily
      },
      {
        'icon': Icons.data_thresholding_outlined,
        'label': AppLang.translate(key: 'home_evaluation', lang: lang ?? 'kh'),
        'route': AppRoutes.evaluate
      },
      {
        'icon': Icons.person_outline_outlined,
        'label':
            AppLang.translate(key: 'home_personal_info', lang: lang ?? 'kh'),
        'route': AppRoutes.personalInfo
      },
      {
        'icon': Icons.work_outline,
        'label': AppLang.translate(key: 'home_job', lang: lang ?? 'kh'),
        'route': AppRoutes.work
      },
      {
        'icon': Icons.monetization_on_outlined,
        'label': AppLang.translate(key: 'home_salary', lang: lang ?? 'kh'),
        'route': AppRoutes.salary
      },
      {
        'icon': Icons.account_box_outlined,
        'label': AppLang.translate(key: 'home_id_card', lang: lang ?? 'kh'),
        'route': null
      },
      {
        'icon': Icons.file_copy_outlined,
        'label': AppLang.translate(key: 'home_document', lang: lang ?? 'kh'),
        'route': null
      },
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 142 / 100,
        padding: EdgeInsets.zero,
        children: menuItems.map((item) {
          return GestureDetector(
            onTap: item['route'] != null
                ? () => context.push(item['route'] as String)
                : null,
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 24,
                    color: HColors.darkgrey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '${item['label']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: HColors.darkgrey,
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Widget for request section
class RequestSection extends StatelessWidget {
  final String selectedIndex;
  final ValueChanged<String> onTabChanged;
  final HomeProvider homeProvider;
  final String Function(String) formatDateToDDMMYY;

  const RequestSection({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.homeProvider,
    required this.formatDateToDDMMYY,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabChanged('Pending'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: selectedIndex == 'Pending'
                            ? Colors.white
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          AppLang.translate(
                              key: 'home_request', lang: lang ?? 'kh'),
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.bodySmall!.fontSize,
                            fontWeight: FontWeight.w500,
                            color: selectedIndex == 'Pending'
                                ? Colors.blue
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabChanged('Reviewing'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: selectedIndex == 'Reviewing'
                            ? Colors.white
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          AppLang.translate(
                              key: 'home_review', lang: lang ?? 'kh'),
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.bodySmall!.fontSize,
                            fontWeight: FontWeight.w500,
                            color: selectedIndex == 'Reviewing'
                                ? Colors.blue
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...(homeProvider.requestData?.data.results ?? []).map((item) {
            if (item['request_status']['name_en'] == selectedIndex) {
              return RequestCard(
                item: item,
                formatDateToDDMMYY: formatDateToDDMMYY,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

// Widget for request card
class RequestCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final String Function(String) formatDateToDDMMYY;

  const RequestCard({
    super.key,
    required this.item,
    required this.formatDateToDDMMYY,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;

    return GestureDetector(
      onTap: () {
        // GestureDetector(
        //                     onTap: () {
        //                       context.push(
        //                         '${AppRoutes.detailRequest}/1}',
        //                       );
        //                     },
        //                     child: Text('Something when wrong'),
        //                   ),
        context.push(
          '${AppRoutes.detailRequest}/${item['id']}',
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLang.translate(
                          data: item['request_category'], lang: lang ?? 'kh'),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '${formatDate(item['start_datetime'])} to ${formatDate(item['end_datetime'])}',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .fontSize,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: ShapeDecoration(
                            color: const Color(0x193B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          // child: Text(
                          //   '4 ថ្ងៃ',
                          //   style: TextStyle(
                          //     color: const Color(0xFF3B82F6),
                          //     fontSize: 10,
                          //     fontFamily: 'Kantumruy Pro',
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          child: Text(
                            calculateDateDifference(
                                item['start_datetime'], item['end_datetime']),
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .fontSize,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppLang.translate(data: item['request_type'], lang: lang ?? 'kh')} | ${formatStringValue(item['objective'])}',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall!.fontSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              // decoration: ShapeDecoration(
              //   color: const Color(0x19F59E0B),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              // ),
              //   child: Text(
              //     'កំពុងរង់ចាំ',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       color: const Color(0xFFF59E0B),
              //       fontSize: 10,
              //       fontFamily: 'Kantumruy Pro',
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: ShapeDecoration(
                  color: const Color(0x19F59E0B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLang.translate(
                      data: item['request_status'], lang: lang ?? 'kh'),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
