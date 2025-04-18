import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/home_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
      child: Consumer2<HomeProvider, SettingProvider>(
        builder: (context, homeProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: homeProvider.isLoading
                ? const Skeleton()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        UserProfileHeader(homeProvider: homeProvider),
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
          );
        },
      ),
    );
  }
}

// Widget for user profile header
class UserProfileHeader extends StatelessWidget {
  final HomeProvider homeProvider;

  const UserProfileHeader({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[600],
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 30.0, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 6.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLang.translate(
                            data: homeProvider.name, lang: lang ?? 'kh'),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLang.translate(
                            data: homeProvider.department, lang: lang ?? 'kh'),
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
          ),
          Row(
            children: [
              _IconButton(icon: Icons.download, onPressed: null),
              const SizedBox(width: 8.0),
              _IconButton(icon: Icons.notifications, onPressed: null),
            ],
          ),
        ],
      ),
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
        color: Colors.grey[200],
      ),
      child: Center(
        child: Icon(icon, color: Colors.grey[600], size: 22.0),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
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
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    Text(
                      '03-03-2025',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(Icons.calendar_today,
                        size: 16.0, color: Colors.grey[800]),
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
                percent: clampToZeroOne(
                    homeProvider.scanByDayData?.data['percentage'] ?? 0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${convertToHoursAndMinutes(homeProvider.scanByDayData?.data['working_hour'] ?? 0)['hours']} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')}',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text(
                      '${convertToHoursAndMinutes(homeProvider.scanByDayData?.data['working_hour'] ?? 0)['minutes']} ${AppLang.translate(key: 'minute', lang: lang ?? 'kh')}',
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
                      terminal:
                          homeProvider.scanByDayData?.data['first_terminal_log']
                              ['terminal_device']['name'],
                      group:
                          homeProvider.scanByDayData?.data['first_terminal_log']
                              ['terminal_device']['group'],
                    ),
                    const SizedBox(height: 12.0),
                    CheckInOutCard(
                      isCheckIn: false,
                      time: formatTimeToHour(
                          homeProvider.scanByDayData?.data['check_out']),
                      terminal:
                          homeProvider.scanByDayData?.data['last_terminal_log']
                              ['terminal_device']['name'],
                      group:
                          homeProvider.scanByDayData?.data['last_terminal_log']
                              ['terminal_device']['group'],
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
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
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    Text(
                      lang == 'en' ? 'February 2025' : 'កុម្ភៈ 2025',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(Icons.calendar_today,
                        size: 16.0, color: Colors.grey[800]),
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
                        '${AppLang.translate(key: 'home_daily', lang: lang ?? 'kh')} ${convertToHoursAndMinutes(homeProvider.scanByMonthData?.data['avg_per_day'] ?? 0)['hours']} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')} ${convertToHoursAndMinutes(homeProvider.scanByMonthData?.data['avg_per_day'] ?? 0)['minutes']} ${AppLang.translate(key: 'minute', lang: lang ?? 'kh')}',
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
              LinearPercentIndicator(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                lineHeight: 25.0,
                center: Text(
                  "${getHoursFromSumHour(homeProvider.scanByMonthData?.data['sum_hour'])} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')} / ${homeProvider.scanByMonthData?.data['max_hour'] ?? '...'} ${AppLang.translate(key: 'hour', lang: lang ?? 'kh')}",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                percent: clampToZeroOne(
                    homeProvider.scanByMonthData?.data['percentage'] ?? 0),
                backgroundColor: Colors.grey[300],
                progressColor: Colors.blue[400],
                barRadius: const Radius.circular(4.0),
                animation: true,
                animationDuration: 500,
              ),
            ],
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
    final lang = Provider.of<SettingProvider>(context).lang;
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
        'route': null
      },
      {
        'icon': Icons.person_outline_outlined,
        'label':
            AppLang.translate(key: 'home_personal_info', lang: lang ?? 'kh'),
        'route': null
      },
      {
        'icon': Icons.work_outline,
        'label': AppLang.translate(key: 'home_job', lang: lang ?? 'kh'),
        'route': null
      },
      {
        'icon': Icons.monetization_on_outlined,
        'label': AppLang.translate(key: 'home_salary', lang: lang ?? 'kh'),
        'route': null
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
        childAspectRatio: 1.3,
        children: menuItems.map((item) {
          return GestureDetector(
            onTap: item['route'] != null
                ? () => context.push(item['route'] as String)
                : null,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 24.0,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
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
                            fontWeight: FontWeight.bold,
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
                            fontWeight: FontWeight.bold,
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLang.translate(
                    data: item['request_category'], lang: lang ?? 'kh'),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.yellow[300]!, Colors.yellow[500]!]),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  AppLang.translate(
                      data: item['request_status'], lang: lang ?? 'kh'),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${formatDate(item['start_datetime'])} to ${formatDate(item['end_datetime'])}',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue[100]!, Colors.blue[200]!]),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  calculateDateDifference(
                      item['start_datetime'], item['end_datetime']),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${AppLang.translate(data: item['request_type'], lang: lang ?? 'kh')} | ${formatStringValue(item['objective'])}',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),
          ),
        ],
      ),
    );
  }
}
