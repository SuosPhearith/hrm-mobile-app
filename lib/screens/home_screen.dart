import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
          child: Column(
        children: [
          Header(),
          FirstDashboard(),
          Notify(),
          Functions(),
          Request()
        ],
      )),
    );
  }
}

class Request extends StatelessWidget {
  const Request({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Text(
                        'ស្នើសុំ',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 4.0),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'ត្រួតពិនិត្យ',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'P-12345',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          'កំពុងរង់ចាំ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Text(
                        '20-01-2025 ដល់ 23-01-2025',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Text(
                          '4 ថ្ងៃ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Spacing between sections
                  // Third Row: Description
                  const Text(
                    'បេសកម្ម (ក្នុងប្រទេស) គ្រោះថ្នាក់ចរាចណ៍',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'P-12345',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          'កំពុងរង់ចាំ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Text(
                        '20-01-2025 ដល់ 23-01-2025',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Text(
                          '4 ថ្ងៃ',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Spacing between sections
                  // Third Row: Description
                  const Text(
                    'បេសកម្ម (ក្នុងប្រទេស) គ្រោះថ្នាក់ចរាចណ៍',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Notify extends StatelessWidget {
  const Notify({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 245, 210),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors
                        .amber.shade700, // Slightly darker amber for contrast
                    size: 24.0, // Consistent size
                  ),
                  const SizedBox(width: 12.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'សារសំខាន់',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold, // Bold for emphasis
                            color: Colors.amber.shade900, // Professional tone
                          ),
                        ),
                        const SizedBox(
                            height: 4.0), // Spacing between title and subtitle
                        Text(
                          'សូមភ្ជាប់តេលេក្រាមដើម្បីទទួលបានដំណឹងផ្សេងៗ',
                          style: TextStyle(
                            fontSize: 12.0, // Slightly larger for readability
                            color: Colors
                                .grey.shade800, // Neutral, professional color
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade600, // Subtle color for close button
                size: 20.0, // Smaller size for balance
              ),
              onPressed: () {
                // Add your close action here
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius:
                  20.0, // Smaller splash radius for cleaner interaction
            ),
          ],
        ),
      ),
    );
  }
}

class Functions extends StatelessWidget {
  const Functions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_calendar_outlined,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'សំណើរ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.face,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ស្កេន',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ប្រចាំថ្ងៃ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.data_thresholding_outlined,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'វាយតម្លៃ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline_outlined,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ព័ត៌មានផ្ទាល់ខ្លួន',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_outline,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ការងារ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ប្រាក់បៀវត្សរ៍',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_box_outlined,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ប័ណ្ណសម្គាល់ខ្លួន',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.file_copy_outlined,
                size: 30,
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.0),
              Text(
                'ឯកសារ',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.person,
                      size: 30,
                    )),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ខួច គឿន'),
                        Text(
                          'អនុប្រធាននាកយកដ្ឋាន​ | អគលេខាធិការដ្ឋាននៃ ក.អ.ក',
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
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(Icons.download)),
                ),
                SizedBox(width: 8.0),
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(Icons.notifications)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FirstDashboard extends StatefulWidget {
  const FirstDashboard({
    super.key,
  });

  @override
  State<FirstDashboard> createState() => _FirstDashboardState();
}

class _FirstDashboardState extends State<FirstDashboard> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: SizedBox(
        height: 250,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildDashboardCard('ថ្ងៃនេះ', '03-03-2025', '7 ម៉ោង',
                      '30 នាទី', '9:00 AM', 'UAT Terminal 3 | អគារ ក'),
                  _buildDashboardCard('ថ្ងៃស្អែក', '04-03-2025', '8 ម៉ោង',
                      '15 នាទី', '10:00 AM', 'UAT Terminal 2 | អគារ ខ'),
                  _buildDashboardCard('ថ្ងៃខានស្អែក', '05-03-2025', '6 ម៉ោង',
                      '45 នាទី', '8:30 AM', 'UAT Terminal 1 | អគារ គ'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.blue.shade600
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String day, String date, String hours,
      String minutes, String time, String location) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hours,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        Text(
                          minutes,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border:
                            Border.all(color: Colors.grey.shade200, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.logout,
                              size: 20.0,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 13.0,
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
                    SizedBox(height: 12.0),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border:
                            Border.all(color: Colors.grey.shade200, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(
                              Icons.logout,
                              size: 20.0,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 13.0,
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
