import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Clean, soft background
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showMonthPicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedMonth != null
                    ? "ប្រចាំថ្ងៃ - ${_getMonthName(_selectedMonth!.month)}"
                    : "ប្រចាំថ្ងៃ - មីនា",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4.0),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.black),
            onPressed: () {},
            splashRadius: 20.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDailyCard(
                date: '15-02-2025',
                loginTime: '08:30',
                logoutTime: '08:30',
                hours: '08:00 h',
                percent: 0.5,
              ),
              const SizedBox(height: 12.0),
              _buildDailyCard(
                date: '15-02-2025',
                loginTime: '08:30',
                logoutTime: '08:30',
                hours: '08:00 h',
                percent: 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'ជ្រើសរើសខែ និងឆ្នាំ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: Colors.blue[700]),
                        onPressed: () {
                          setModalState(() {
                            _focusedDay = DateTime(
                                _focusedDay.year - 1, _focusedDay.month);
                          });
                        },
                      ),
                      Text(
                        '${_focusedDay.year}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.chevron_right, color: Colors.blue[700]),
                        onPressed: () {
                          setModalState(() {
                            _focusedDay = DateTime(
                                _focusedDay.year + 1, _focusedDay.month);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final khmerMonths = [
                            'មករា',
                            'កុម្ភៈ',
                            'មីនា',
                            'មេសា',
                            'ឧសភា',
                            'មិថុនា',
                            'កក្កដា',
                            'សីហា',
                            'កញ្ញា',
                            'តុលា',
                            'វិច្ឆិកា',
                            'ធ្នូ'
                          ];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMonth =
                                    DateTime(_focusedDay.year, index + 1);
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[50]!,
                                    Colors.white,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  khmerMonths[index],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(color: Colors.blue[700]!, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: Text(
                          'បោះបង់',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const khmerMonths = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ',
    ];
    return khmerMonths[month - 1];
  }

  Widget _buildDailyCard({
    required String date,
    required String loginTime,
    required String logoutTime,
    required String hours,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        children: [
          Container(
            width: 8.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.login, color: Colors.blue[700], size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      loginTime,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Icon(Icons.logout, color: Colors.blue[700], size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      logoutTime,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: LinearPercentIndicator(
                        width: 100.0,
                        lineHeight: 8.0,
                        percent: percent,
                        backgroundColor: Colors.grey[300],
                        progressColor: Colors.blue[700],
                        barRadius: const Radius.circular(4.0),
                        animation: true,
                        animationDuration: 500,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      hours,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
