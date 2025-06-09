import 'dart:math' as math;

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
import 'package:mobile_app/widgets/skeleton/home_skeleton.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for QR code

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
                  ? const HomeSkeleton()
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          UserProfileHeader(authProvider: authProvider),
                          SizedBox(
                            height: 10,
                          ),
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

// Widget for user profile header
class UserProfileHeader extends StatelessWidget {
  final AuthProvider authProvider;

  const UserProfileHeader({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;

    return AppBar(
      // backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: InkWell(
        onTap: (){
          context.push(AppRoutes.profile);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Stack(
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
                              child: Icon(Icons.person,
                                  size: 30.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          // onTap: () {
                          //   // Handle close/remove action
                          //   setState(() {
                          //     selectedItems
                          //         .value = List.from(selected)
                          //       ..removeWhere(
                          //           (s) => s['id'] == userId);
                          //   });
                          // },
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: HColors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
        height: 220,
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
                  FlippableCardView(
                      homeProvider:
                          homeProvider), // Updated to use FlippableCardView
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                // Updated to 3 for the three pages
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: index == currentIndex ? 12.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        index == currentIndex ? HColors.blue : Colors.grey[300],
                  ),
                );
              }),
            ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
            image: AssetImage('lib/assets/images/Kbach-2.png'),
            fit: BoxFit.contain,
            opacity: 0.3,
            alignment: Alignment.centerRight),
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
        border: Border.all(color: HColors.darkgrey.withOpacity(0.1)),
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
        image: DecorationImage(
            image: AssetImage(
              'lib/assets/images/Kbach-2.png',
            ),
            fit: BoxFit.scaleDown,
            opacity: 0.3,
            alignment: Alignment.centerRight),
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

class RotatedImagePainter extends CustomPainter {
  final String imagePath;
  final double rotationAngle;

  RotatedImagePainter({required this.imagePath, required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotationAngle);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FlippableCardView extends StatefulWidget {
  final HomeProvider homeProvider;

  const FlippableCardView({super.key, required this.homeProvider});

  @override
  _FlippableCardViewState createState() => _FlippableCardViewState();
}

class _FlippableCardViewState extends State<FlippableCardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final isFrontVisible = angle < math.pi / 2 || angle > 3 * math.pi / 2;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFrontVisible
                ? CardView(homeProvider: widget.homeProvider)
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: BackCardView(),
                  ),
          );
        },
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return CustomPaint(
      painter: RotatedImagePainter(
        imagePath: 'lib/assets/images/Kbach-2.png',
        rotationAngle: 3.14159, // 180 degrees in radians
      ),
      child: Container(
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
          image: DecorationImage(
            image: AssetImage('lib/assets/images/Kbach-2.png'),
            fit: BoxFit.contain,
            opacity: 0.3,
            alignment: Alignment.centerLeft,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getSafeString(
                                safeValue: '...',
                                value: authProvider.profile?.data['user']
                                    ?['name_kh']),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: HColors.blue,
                            ),
                          ),
                          SizedBox(height: 2),
                          SizedBox(
                            width: 220,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                Text(
                                  "${AppLang.translate(data: authProvider.profile?.data['user']['roles'][0]['department'], lang: lang ?? 'kh')} | ${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['user_work']?['staff_type'])}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Text(
                                //   AppLang.translate(
                                //       lang: lang ?? 'kh',
                                //       data: authProvider.profile?.data['user']
                                //           ?['user_work']?['staff_type']),
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2),
                          Container(
                            width: 30,
                            height: 1,
                            color: Color(0xFFDDAD01),
                          ),
                        ],
                      ),
                    ),
                    _buildContactRow(
                      Icons.phone_android_sharp,
                      '${getSafeString(value: authProvider.profile?.data['user']?['phone_number'])} ',
                    ),
                    const SizedBox(height: 4),
                    _buildContactRow(
                      Icons.email,
                      '${getSafeString(value: authProvider.profile?.data['user']?['email'])} ',
                    ),
                    const SizedBox(height: 4),
                    _buildContactRow(
                      Icons.location_on,
                      '${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['village'])} ,${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['commune'])} ,${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['district'])} ,${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['province'])}  ',
                      isAddress: true,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        authProvider.profile?.data['user']['avatar'] != null
                            ? NetworkImage(
                                '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                              )
                            : null,
                    child: authProvider.profile?.data['user']['avatar'] == null
                        ? const Icon(Icons.person,
                            size: 30.0, color: Colors.white)
                        : null,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  QrImageView(
                    data: getSafeString(
                        value:
                            authProvider.profile?.data['user']?['email'] ?? ''),
                    version: QrVersions.auto,
                    size: 70.0,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text,
      {bool isAddress = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 3),
          child: Icon(
            icon,
            size: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 210,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            // spacing: 2,
            //                   runSpacing: 2,
            children: [
              Text(
                text,
                style: const TextStyle(
                  // color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                maxLines: isAddress ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BackCardView extends StatelessWidget {
  const BackCardView({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Stack(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: Icon(
          //         Icons.more_vert_outlined,
          //       ),
          //     ),
          //   ],
          // ),
          // Top-left background image
          Positioned(
            left: -30,
            top: -30,
            child: Opacity(
              opacity: 0.5, // Lower opacity for subtle background
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/f.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Bottom-right background image
          Positioned(
            right: -30,
            bottom: -30,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/f.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('lib/assets/images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "ក្រុមប្រឹក្សារអភិវឌ្ឍកម្ពុជា",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    // color: Color(0xFFDDAD01),
                    // fontFamily: 'Kantumruy Pro',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "Council for the Development of Cambodia",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the row
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.location_on,
                        size: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      // Use Flexible to prevent overflow
                      child: Text(
                        'វិមានរាជរដ្ឋាភិបាល, វិថីសុីសុវត្ថិ, វត្តភ្នំ, ភ្នំពេញ',
                        style: const TextStyle(
                          // color: Color(0xFF0F172A),
                          fontSize: 12,

                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                            TextAlign.center, // Center text within the Flexible
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url = 'https://www.youtube.com';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          // Handle error (e.g., show a snackbar)
                          // print('Could not launch $url');
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.email,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'info@cdc.gov.kh',
                            style: TextStyle(
                              // decoration:
                              //     TextDecoration.underline, // Adds underline
                              color: HColors.darkgrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+855 99 799 579',
                      style: TextStyle(fontSize: 12, color: HColors.darkgrey),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = 'www.cdc.gov.kh';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          // Handle error (e.g., show a snackbar)
                          print('Could not launch $url');
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.language,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'www.cdc.gov.kh',
                            style: TextStyle(
                              // decoration:
                              //     TextDecoration.underline, // Adds underline
                              color: HColors.darkgrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
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
        color: Colors.white,
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
        'route': AppRoutes.card
      },
      {
        'icon': Icons.file_copy_outlined,
        'label': AppLang.translate(key: 'home_document', lang: lang ?? 'kh'),
        'route': AppRoutes.document
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
                      // color: HColors.darkgrey,
                      fontWeight: FontWeight.w400,
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
