import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HollidayScreen extends StatefulWidget {
  const HollidayScreen({super.key});

  @override
  State<HollidayScreen> createState() => _HollidayScreenState();
}

class _HollidayScreenState extends State<HollidayScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Map of Cambodian holidays (example dates for 2025)
  final Map<DateTime, List<String>> _holidays = {
    DateTime(2025, 1, 1): ['ថ្ងៃចូលឆ្នាំសកល'], // New Year's Day
    DateTime(2025, 4, 13): ['ថ្ងៃចូលឆ្នាំខ្មែរ'], // Khmer New Year
    DateTime(2025, 5, 13): ['ពិធីបុណ្យវិសាខបូជា'], // Visak Bochea
    DateTime(2025, 9, 24): ['ទិវាបុណ្យភ្ជុំបិណ្ឌ'], // Pchum Ben
    DateTime(2025, 11, 10): ['ទិវាឯករាជ្យជាតិ'], // Independence Day
  };

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('km_KH', null);
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            locale: 'km_KH',
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade300,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
              ),
              holidayTextStyle: const TextStyle(color: Colors.red),
            ),
            holidayPredicate: (day) {
              return _holidays
                  .containsKey(DateTime(day.year, day.month, day.day));
            },
            calendarBuilders: CalendarBuilders(
              holidayBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildEventList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    // Filter holidays for the current month
    final monthHolidays = _holidays.entries.where((entry) {
      return entry.key.year == _focusedDay.year &&
          entry.key.month == _focusedDay.month;
    }).toList();

    return monthHolidays.isEmpty
        ? const Center(
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
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: ListTile(
                  leading: const Icon(Icons.celebration, color: Colors.blue),
                  title: Text(holiday.value.first),
                  subtitle: Text(
                    DateFormat.yMMMMd('km_KH').format(holiday.key),
                  ),
                ),
              );
            },
          );
  }
}
