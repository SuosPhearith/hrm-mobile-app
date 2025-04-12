import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/local/home_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/skeleton.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

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
    final year = dateTime.year.toString(); // Get last 2 digits

    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: homeProvider.isLoading
                ? Skeleton()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
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
                                        child: Icon(
                                          Icons.person,
                                          size: 30.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6.0),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            homeProvider.name ?? 'មិនមានឈ្មោះ',
                                            style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .fontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            homeProvider.department ??
                                                'មិនមានផ្នែក',
                                            style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .fontSize,
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
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: Center(
                                      child: Icon(Icons.download,
                                          color: Colors.grey[600], size: 22.0),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: Center(
                                      child: Icon(Icons.notifications,
                                          color: Colors.grey[600], size: 22.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: SizedBox(
                            height: 220,
                            child: Column(
                              children: [
                                Expanded(
                                  child: PageView(
                                    controller: PageController(initialPage: 0),
                                    onPageChanged: (int page) {
                                      setState(() {
                                        _currentIndex = page;
                                      });
                                    },
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(13.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.grey[50]!
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'ថ្ងៃនេះ',
                                                  style: TextStyle(
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '03-03-2025',
                                                        style: TextStyle(
                                                          fontSize:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .fontSize,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.0),
                                                      Icon(Icons.calendar_today,
                                                          size: 16.0,
                                                          color:
                                                              Colors.grey[800]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16.0),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 50.0,
                                                  lineWidth: 8.0,
                                                  percent: clampToZeroOne(
                                                      homeProvider.scanByDayData
                                                                  ?.data[
                                                              'percentage'] ??
                                                          0),
                                                  center: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${convertToHoursAndMinutes(homeProvider.scanByDayData?.data['working_hour'])['hours']} ម៉ោង',
                                                        style: TextStyle(
                                                          fontSize:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .fontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.blue[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        '${convertToHoursAndMinutes(homeProvider.scanByDayData?.data['working_hour'])['minutes']} នាទី',
                                                        style: TextStyle(
                                                          fontSize:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .fontSize,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  progressColor:
                                                      Colors.blue[700],
                                                  backgroundColor:
                                                      Colors.grey[200]!,
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  animation: true,
                                                  animationDuration: 1000,
                                                ),
                                                const SizedBox(width: 20.0),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade200),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(6.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Icon(
                                                                Icons.logout,
                                                                size: 20.0,
                                                                color: Colors
                                                                    .blue[800],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 6.0),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    formatTimeToHour(homeProvider
                                                                        .scanByDayData
                                                                        ?.data['check_in']),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .fontSize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${homeProvider.scanByDayData?.data['first_terminal_log']['terminal_device']['name'] ?? '...'} | ${homeProvider.scanByDayData?.data['first_terminal_log']['terminal_device']['group'] ?? '...'}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .fontSize,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 12.0),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade200),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(6.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Icon(
                                                                Icons.logout,
                                                                size: 20.0,
                                                                color: Colors
                                                                    .blue[800],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 6.0),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    formatTimeToHour(homeProvider
                                                                        .scanByDayData
                                                                        ?.data['check_out']),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .fontSize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${homeProvider.scanByDayData?.data['last_terminal_log']['terminal_device']['name'] ?? '...'} | ${homeProvider.scanByDayData?.data['last_terminal_log']['terminal_device']['group'] ?? '...'}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .fontSize,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(13.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.grey[50]!
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'ប្រចាំខែ',
                                                  style: TextStyle(
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'កុម្ភះ 2025',
                                                        style: TextStyle(
                                                          fontSize:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .fontSize,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4.0),
                                                      Icon(Icons.calendar_today,
                                                          size: 16.0,
                                                          color:
                                                              Colors.grey[800]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16.0),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300]!,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          // Icon placeholder
                                                          Icon(
                                                            Icons.work_history,
                                                            size: 28.0,
                                                            color: Colors
                                                                .green[800],
                                                          ),
                                                          const SizedBox(
                                                              width: 12),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${homeProvider.scanByMonthData?.data['sum_hour'] ?? '...'} ម៉ោង',
                                                                style: TextStyle(
                                                                    fontSize: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .fontSize),
                                                              ),
                                                              Text(
                                                                'មធ្យម​ ${convertToHoursAndMinutes(homeProvider.scanByMonthData?.data['avg_per_day'])['hours']}ម៉ោង ${convertToHoursAndMinutes(homeProvider.scanByMonthData?.data['avg_per_day'])['minutes']}នាទី/ថ្ងៃ',
                                                                style: TextStyle(
                                                                    fontSize: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .fontSize),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Three similar stat containers
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0,
                                                              bottom: 5.0,
                                                              right: 15,
                                                              left: 15),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300]!,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.person_off,
                                                            size: 20.0,
                                                            color:
                                                                Colors.red[800],
                                                          ),
                                                          Text(
                                                              '${homeProvider.scanByMonthData?.data['absence'] ?? '...'}'),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0,
                                                              bottom: 5.0,
                                                              right: 15,
                                                              left: 15),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300]!,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .person_outline_sharp,
                                                            size: 20.0,
                                                            color: Colors
                                                                .orange[800],
                                                          ),
                                                          Text(
                                                              '${homeProvider.scanByMonthData?.data['leave'] ?? '...'}'),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0,
                                                              bottom: 5.0,
                                                              right: 15,
                                                              left: 15),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300]!,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .airplanemode_on_sharp,
                                                            size: 20.0,
                                                            color: Colors
                                                                .blue[800],
                                                          ),
                                                          Text(
                                                              '${homeProvider.scanByMonthData?.data['mission'] ?? '...'}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 6.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'សរុបម៉ោងធ្វើការ',
                                                      style: TextStyle(
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .fontSize,
                                                      ),
                                                    ),
                                                    Text(
                                                      'ទទួលនិទ្ទេស​ ${homeProvider.scanByMonthData?.data['grade'] ?? '...'}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .fontSize,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4.0,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          LinearPercentIndicator(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    0.0),
                                                        lineHeight: 25.0,
                                                        center: Text(
                                                          "${homeProvider.scanByMonthData?.data['sum_hour'] ?? '...'} ម៉ោង / ${homeProvider.scanByMonthData?.data['max_hour'] ?? '...'} ម៉ោង",
                                                          style: TextStyle(
                                                            fontSize: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .fontSize,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        percent: clampToZeroOne(
                                                            homeProvider
                                                                    .scanByMonthData
                                                                    ?.data[
                                                                'percentage']),
                                                        backgroundColor:
                                                            Colors.grey[300],
                                                        progressColor:
                                                            Colors.blue[400],
                                                        barRadius: const Radius
                                                            .circular(4.0),
                                                        animation: true,
                                                        animationDuration: 500,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(2, (index) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: index == 0 ? 12.0 : 8.0,
                                      height: 8.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == _currentIndex
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                            childAspectRatio: 1.3,
                            children: [
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.request),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit_calendar_outlined,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'សំណើរ',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.scan),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.face,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ស្កេន',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.daily),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ប្រចាំថ្ងៃ',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.data_thresholding_outlined,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'វាយតម្លៃ',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_outline_outlined,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ព័ត៌មានផ្ទាល់ខ្លួន',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.work_outline,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ការងារ',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ប្រាក់បៀវត្សរ៍',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.account_box_outlined,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ប័ណ្ណសម្គាល់ខ្លួន',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_copy_outlined,
                                        size: 24.0,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'ឯកសារ',
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 'Pending';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 'Pending'
                                                ? Colors.white
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ស្នើសុំ',
                                              style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .fontSize,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    selectedIndex == 'Pending'
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
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 'Success';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 'Success'
                                                ? Colors.white
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ត្រួតពិនិត្យ',
                                              style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .fontSize,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    selectedIndex == 'Success'
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
                              ...(homeProvider.requestData?.data.results ?? [])
                                  .map((item) {
                                if (item['request_status']['name_en'] ==
                                    selectedIndex) {
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 12.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[100]!,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'P-12345',
                                              style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .fontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.yellow[300]!,
                                                    Colors.yellow[500]!
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Text(
                                                '${item['request_status']['name_kh'] ?? '...'}',
                                                style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .fontSize,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${formatDateToDDMMYY(item['start_datetime'])} ដល់ ${formatDateToDDMMYY(item['end_datetime'])}',
                                              style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .fontSize,
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.blue[100]!,
                                                    Colors.blue[200]!
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Text(
                                                '4 ថ្ងៃ',
                                                style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .fontSize,
                                                  color: Colors.blue.shade800,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${item['request_type']['name_kh']} ${item['request_category']['name_kh']}',
                                          style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .fontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Text('');
                              }),
                            ],
                          ),
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
