import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  String? nameKh, avatar, department;
  int _currentIndex = 0;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    final String loadedName = await storage.read(key: 'name_kh') ?? '';
    final String loadedEmail = await storage.read(key: 'avatar') ?? '';
    final String loadedDepart = await storage.read(key: 'department') ?? '';
    if (!mounted) return;
    setState(() {
      nameKh = loadedName;
      avatar = loadedEmail;
      department = loadedDepart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameKh ?? 'មិនមានឈ្មោះ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              Text(
                                department ?? 'មិនមានផ្នែក',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey.shade600,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ថ្ងៃនេះ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '03-03-2025',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          Icon(Icons.calendar_today,
                                              size: 16.0,
                                              color: Colors.grey[800]),
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
                                      percent: 0.7,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '7 ម៉ោង',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          Text(
                                            '30 នាទី',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      progressColor: Colors.blue[700],
                                      backgroundColor: Colors.grey[200]!,
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
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout,
                                                    size: 20.0,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '9:00 AM',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'UAT Terminal 3 | អគារ ក',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12.0),
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout,
                                                    size: 20.0,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '9:00 AM',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'UAT Terminal 3 | អគារ ក',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                        overflow: TextOverflow
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ថ្ងៃស្អែក',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '04-03-2025',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          Icon(Icons.calendar_today,
                                              size: 16.0,
                                              color: Colors.grey[800]),
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
                                      percent: 0.7,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '8 ម៉ោង',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          Text(
                                            '15 នាទី',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      progressColor: Colors.blue[700],
                                      backgroundColor: Colors.grey[200]!,
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
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout,
                                                    size: 20.0,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '10:00 AM',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'UAT Terminal 2 | អគារ ខ',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12.0),
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout,
                                                    size: 20.0,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '10:00 AM',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'UAT Terminal 2 | អគារ ខ',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                        overflow: TextOverflow
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ថ្ងៃខានស្អែក',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '05-03-2025',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          Icon(Icons.calendar_today,
                                              size: 16.0,
                                              color: Colors.grey[800]),
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
                                      percent: 0.7,
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '6 ម៉ោង',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          Text(
                                            '45 នាទី',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      progressColor: Colors.blue[700],
                                      backgroundColor: Colors.grey[200]!,
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
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout,
                                                    size: 20.0,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '8:30 AM',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'UAT Terminal 1 | អគារ គ',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12.0),
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.logout,
                                                    size: 20.0,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '8:30 AM',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        'UAT Terminal 1 | អគារ គ',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                        overflow: TextOverflow
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: index == 0 ? 12.0 : 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Center(
                                child: Text(
                                  'ស្នើសុំ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Text(
                                  'ត្រួតពិនិត្យ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                              'P-12345',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow[300]!,
                                    Colors.yellow[500]!
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Text(
                                'កំពុងរង់ចាំ',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '20-01-2025 ដល់ 23-01-2025',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.grey.shade700),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[100]!,
                                    Colors.blue[200]!
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                '4 ថ្ងៃ',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blue.shade800),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'បេសកម្ម (ក្នុងប្រទេស) គ្រោះថ្នាក់ចរាចណ៍',
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                              'P-12345',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow[300]!,
                                    Colors.yellow[500]!
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Text(
                                'កំពុងរង់ចាំ',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '20-01-2025 ដល់ 23-01-2025',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.grey.shade700),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[100]!,
                                    Colors.blue[200]!
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                '4 ថ្ងៃ',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blue.shade800),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'បេសកម្ម (ក្នុងប្រទេស) គ្រោះថ្នាក់ចរាចណ៍',
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey.shade600),
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
    );
  }
}
