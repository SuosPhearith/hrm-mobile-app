import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:provider/provider.dart';

// Single Date Picker for use with DateInputField
class CustomSingleDatePicker extends StatefulWidget {
  final DateTime? initialDate;

  const CustomSingleDatePicker({super.key, this.initialDate});

  @override
  _CustomSingleDatePickerState createState() => _CustomSingleDatePickerState();
}

class _CustomSingleDatePickerState extends State<CustomSingleDatePicker> {
  DateTime? selectedDate;
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('km');
      setState(() {
        _localeInitialized = true;
      });
    } catch (e) {
      // Fallback if Khmer locale is not available
      print('Khmer locale not available, using default locale');
      setState(() {
        _localeInitialized = true;
      });
    }
  }

  String _formatDate(DateTime date) {
    if (!_localeInitialized) return '';

    try {
      // Try using Khmer locale first
      return DateFormat('d MMM', 'km').format(date);
    } catch (e) {
      // Fallback to default locale if Khmer is not available
      return DateFormat('d MMM').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            selectedDate != null
                ? _formatDate(selectedDate!)
                : 'ជ្រើសរើសកាលបរិច្ឆេទ',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          trailing: Icon(
            Icons.edit,
            color: HColors.darkgrey,
          ),
        ),
        Divider(
          color: HColors.darkgrey.withOpacity(0.3),
        ),
        CalendarDatePicker(
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
          onDateChanged: (date) {
            setState(() {
              selectedDate = date;
            });
          },
          currentDate: DateTime.now(),
          selectableDayPredicate: (_) => true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLang.translate(
                      lang: Provider.of<SettingProvider>(context, listen: false)
                              .lang ??
                          'kh',
                      key: 'close')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HColors.blue, // Button background color
                    foregroundColor: Colors.white, // Text color

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24), // Rounded corners
                    ),
                    // elevation: 4, // Shadow
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: selectedDate != null
                      ? () {
                          Navigator.pop(context, selectedDate!);
                        }
                      : null,
                  child: Text(AppLang.translate(
                      lang: Provider.of<SettingProvider>(context, listen: false)
                              .lang ??
                          'kh',
                      key: 'confirm')),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Date Range Picker (if you need it for other purposes)
class CustomDateRangePicker extends StatefulWidget {
  const CustomDateRangePicker({super.key});

  @override
  _CustomDateRangePickerState createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? startDate;
  DateTime? endDate;
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('km');
      setState(() {
        _localeInitialized = true;
      });
    } catch (e) {
      // Fallback if Khmer locale is not available
      print('Khmer locale not available, using default locale');
      setState(() {
        _localeInitialized = true;
      });
    }
  }

  String _formatDate(DateTime date) {
    if (!_localeInitialized) return '';

    try {
      // Try using Khmer locale first
      return DateFormat('d MMM', 'km').format(date);
    } catch (e) {
      // Fallback to default locale if Khmer is not available
      return DateFormat('d MMM').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            startDate != null && endDate != null
                ? '${_formatDate(startDate!)} - ${_formatDate(endDate!)}'
                : 'ជ្រើសរើសកាលបរិច្ឆេទ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: const Icon(Icons.edit),
        ),
        const Divider(),
        CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onDateChanged: (date) {
            setState(() {
              if (startDate == null || (startDate != null && endDate != null)) {
                startDate = date;
                endDate = null;
              } else if (startDate != null && endDate == null) {
                if (date.isAfter(startDate!)) {
                  endDate = date;
                } else {
                  startDate = date;
                }
              }
            });
          },
          currentDate: DateTime.now(),
          selectableDayPredicate: (_) => true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('បិទ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: startDate != null && endDate != null
                      ? () {
                          Navigator.pop(
                              context, {'start': startDate!, 'end': endDate!});
                        }
                      : null,
                  child: const Text('យល់ព្រម'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
