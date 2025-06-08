import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/providers/local/holiday_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> parseHolidaysFromApi(List<dynamic>? apiData) {
    final Map<DateTime, List<String>> holidays = {};

    // Return empty map if apiData is null
    if (apiData == null) return holidays;

    for (var holiday in apiData) {
      final date = DateTime.parse(holiday['date']);
      final dateKey = DateTime(date.year, date.month, date.day);
      final holidayName = holiday['name'] as String;
      holidays[dateKey] = [holidayName];
    }

    return holidays;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('km_KH', null);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HolidayProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'ឈប់សម្រាក',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: CustomHeader(),
        ),
        body: provider.isLoading
            ? Text('Loading..')
            : Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2025, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    locale: 'km_KH',
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },

                    // Enhanced Header Styling
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.grey.shade700,
                        size: 28,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade700,
                        size: 28,
                      ),
                      headerPadding: const EdgeInsets.symmetric(vertical: 16.0),
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),

                    // Professional Calendar Styling
                    calendarStyle: CalendarStyle(
                      // Remove default borders and padding
                      cellMargin: const EdgeInsets.all(2.0),
                      cellPadding: const EdgeInsets.all(0),

                      // Today's date styling
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(
                          color: Colors.blue.shade400,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),

                      // Selected day styling
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),

                      // Weekend styling
                      weekendTextStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),

                      // Default day styling
                      defaultTextStyle: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),

                      // Outside month days
                      outsideDaysVisible: false,

                      // Holiday styling (will be overridden by custom builder)
                      holidayTextStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),

                      // Header styling for days of week
                      tablePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),

                    // Days of week styling
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    // Holiday predicate
                    holidayPredicate: (day) {
                      return parseHolidaysFromApi(provider.data['data'])
                          .containsKey(DateTime(day.year, day.month, day.day));
                    },

                    // Custom builders for enhanced styling
                    calendarBuilders: CalendarBuilders(
                      // Holiday builder with professional styling
                      holidayBuilder: (context, day, focusedDay) {
                        final isSelected = isSameDay(_selectedDay, day);
                        final isToday = isSameDay(DateTime.now(), day);

                        return Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.red.shade600
                                : isToday
                                    ? Colors.red.shade50
                                    : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8.0),
                            border: isToday && !isSelected
                                ? Border.all(
                                    color: Colors.red.shade300, width: 2.0)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.red.shade200,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },

                      // Default day builder for consistent styling
                      defaultBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },

                      // Weekend builder for subtle differentiation
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildEventList(provider),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildEventList(HolidayProvider provider) {
    // Filter holidays for the current month
    final monthHolidays =
        parseHolidaysFromApi(provider.data['data']).entries.where((entry) {
      return entry.key.year == _focusedDay.year &&
          entry.key.month == _focusedDay.month;
    }).toList();

    return monthHolidays.isEmpty
        ? Center(
            child: Text(
              'គ្មានថ្ងៃឈប់សម្រាកនៅក្នុងខែនេះ',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: monthHolidays.length,
            itemBuilder: (context, index) {
              final holiday = monthHolidays[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.E('km_KH').format(holiday
                                .key), // Day of week in Khmer (អង្គារ, ពុធ, etc.)
                            style: const TextStyle(
                              fontSize: 12,
                              // color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${holiday.key.day}', // Day number
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: HColors.bluegreen,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          holiday.value.first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
