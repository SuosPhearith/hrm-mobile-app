import 'dart:convert';

import 'package:intl/intl.dart';

void printError({required String? errorMessage, int? statusCode}) {
  final message = errorMessage ?? 'Unknown error';
  final statusText = statusCode != null ? 'Status: $statusCode - ' : '';
}

String formatTimeToHour(String? isoTimestamp) {
  try {
    if (isoTimestamp == null || isoTimestamp.isEmpty) return 'N/A';
    // Parse the ISO 8601 string into a DateTime object
    DateTime dateTime = DateTime.parse(isoTimestamp);

    // Extract hours and minutes
    int hours = dateTime.hour; // 0-23
    int minutes = dateTime.minute;

    // Convert to 12-hour format
    String period = hours >= 12 ? 'PM' : 'AM';
    int displayHours = hours % 12 == 0 ? 12 : hours % 12;

    // Format minutes with leading zero if needed
    String displayMinutes = minutes < 10 ? '0$minutes' : '$minutes';

    // Return formatted time
    return '$displayHours:$displayMinutes $period';
  } catch (e) {
    // Return "..." if parsing fails or any error occurs
    return '...';
  }
}

Map<String, int> convertToHoursAndMinutes(double? value) {
  if (value == null) return {'hours': 0, 'minutes': 0};
  int hours = value.floor();
  int minutes = ((value - hours) * 60).round();
  if (minutes == 60) {
    hours += 1;
    minutes = 0;
  }
  return {'hours': hours, 'minutes': minutes};
}

double clampToZeroOne(double? value) {
  if (value == null) return 0.0;
  if (value < 0.0) return 0.0;
  if (value > 1.0) return 1.0;
  return value;
}

String convertNumberToString(dynamic value) {
  if (value == null) return '';

  if (value is int || value is double) {
    return value.toString();
  }

  return '';
}

int getHoursFromSumHour(dynamic sumHour) {
  try {
    if (sumHour == null) return 0; // Return 0 if input is null
    final double value = double.parse(sumHour.toString()); // Convert to double
    return value.floor(); // Extract integer part (hours)
  } catch (e) {
    return 0; // Return 0 on any error (e.g., invalid format)
  }
}

String formatDate(
  String? dateString, {
  String format = 'dd-mm-yyyy',
}) {
  // Return empty string if date is null or empty
  if (dateString == null || dateString.isEmpty) {
    return '';
  }

  try {
    // Parse the ISO date string
    DateTime dateTime = DateTime.parse(dateString);

    // Format day, month, and year with leading zeros if needed
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    // Check which format to use
    switch (format.toLowerCase()) {
      case 'dd/mm/yyyy':
        return '$day/$month/$year';
      case 'dd-mm-yyyy':
      default:
        return '$day-$month-$year';
    }
  } catch (e) {
    // Return N/A if parsing fails
    return 'N/A';
  }
}

String formatStringValue(String? value) {
  // Check if the value is null or empty
  if (value == null || value.trim().isEmpty) {
    return 'N/A';
  }

  // Return the original value if it's valid
  return value;
}

String calculateDateDifference(String? startDatetime, String? endDatetime) {
  // Check if either input is null or empty
  if (startDatetime == null ||
      startDatetime.isEmpty ||
      endDatetime == null ||
      endDatetime.isEmpty) {
    return 'N/A';
  }

  try {
    // Parse the ISO date strings
    DateTime startDate = DateTime.parse(startDatetime);
    DateTime endDate = DateTime.parse(endDatetime);

    // Calculate the difference in days
    int differenceInDays = endDate.difference(startDate).inDays +
        1; // +1 to include both start and end dates

    // Return the result as a string
    return '$differenceInDays ថ្ងៃ'; // Days in Khmer
  } catch (e) {
    // Return N/A if parsing fails
    return 'N/A';
  }
}

String formatTimeTo12Hour(String? timeStr) {
  // Return early if timeStr is null
  if (timeStr == null) return '';

  try {
    // Parse the input time string (e.g., "06:00:00")
    final dateTime = DateTime.parse('1970-01-01 $timeStr');
    // Format to 12-hour with AM/PM, removing leading zero from hour
    return DateFormat('h:mm a').format(dateTime);
  } catch (e) {
    return timeStr; // Return original string if parsing fails
  }
}

// For safe String value when null
String getSafeString({dynamic value, String? safeValue}) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return safeValue ?? '...';
}

int getSafeInteger({dynamic value, int? safeValue}) {
  if (value is int) {
    return value;
  }
  return safeValue ?? 0;
}

double getSafeDouble({dynamic value, double? safeValue}) {
  if (value is double) {
    return value;
  }
  // Try to parse if value is a string representation of a number
  if (value is String && double.tryParse(value) != null) {
    return double.parse(value);
  }
  return safeValue ?? 0.0;
}

bool getSafeBoolean({dynamic value, bool? safeValue}) {
  if (value is bool) {
    return value;
  }
  // Try to parse if value is a string representation of a boolean
  if (value is String) {
    final lowerValue = value.toLowerCase();
    if (lowerValue == 'true') return true;
    if (lowerValue == 'false') return false;
  }
  return safeValue ?? false;
}

String convertToString({dynamic value, String? fallback}) {
  if (value == null) {
    return fallback ?? '';
  }
  try {
    // Handle common types
    if (value is String) {
      return value;
    } else if (value is int || value is double || value is bool) {
      return value.toString();
    } else if (value is DateTime) {
      // Format DateTime as ISO 8601 or custom format
      return value.toIso8601String();
    } else if (value is List || value is Map) {
      // Handle collections (basic string representation)
      return value.toString();
    } else {
      // Fallback for other types
      return value.toString();
    }
  } catch (e) {
    // Return fallback if conversion fails
    return fallback ?? '';
  }
}

// For paste date time and covert 2025-05-11T00:00:00.128Z =>  dd-MM-yyyy and 5:00PM
Map<String, String> parseDateTime(String dateTimeString) {
  try {
    // Parse the input datetime string
    final dateTime = DateTime.parse(dateTimeString);

    // Format date as YYYY-MM-DD
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final formattedDate = dateFormatter.format(dateTime);

    // Format time as h:mm a (e.g., 5:00 PM)
    final timeFormatter = DateFormat('h:mm a');
    final formattedTime = timeFormatter.format(dateTime);

    return {
      'date': formattedDate,
      'time': formattedTime,
    };
  } catch (e) {
    // Return N/A for both date and time if parsing fails
    return {
      'date': 'N/A',
      'time': 'N/A',
    };
  }
}

String convertToHoursMinutes({dynamic value}) {
  try {
    // Ensure the input can be converted to a double
    double hours;
    if (value is double) {
      hours = value;
    } else if (value is int) {
      hours = value.toDouble();
    } else if (value is String) {
      hours = double.tryParse(value) ?? double.nan;
    } else {
      return 'N/A';
    }

    // Check for invalid or negative values
    if (hours.isNaN || hours.isInfinite || hours < 0) {
      return 'N/A';
    }

    // Extract hours and minutes
    int wholeHours = hours.floor();
    double fractionalHours = hours - wholeHours;
    int minutes = (fractionalHours * 60).round(); // Convert decimal to minutes

    // Handle edge case where rounding minutes results in 60
    if (minutes >= 60) {
      wholeHours += 1;
      minutes = 0;
    }

    // Format as "HHH MM"
    return '${wholeHours}h ${minutes.toString().padLeft(2, '0')}min';
  } catch (e) {
    return 'N/A';
  }
}

// 19-05-2025 23:08
String formatDateTime(String isoString) {
  try {
    DateTime parsedDate =
        DateTime.parse(isoString).toLocal(); // Convert to local time
    return DateFormat('dd-MM-yyyy HH:mm').format(parsedDate);
  } catch (e) {
    return ''; // or handle the error
  }
}

List<dynamic> mapToList(dynamic input) {
  // Handle null input
  if (input == null) return [];

  try {
    if (input is List<dynamic>) {
      // If input is already a List<dynamic>, return it
      return input;
    } else if (input is Map<String, dynamic>) {
      // If input is a Map<String, dynamic>, convert values to list
      if (input.isEmpty) return [];
      return input.values.toList();
    } else {
      // Return empty list for unsupported types
      return [];
    }
  } catch (e) {
    // Return empty list if conversion fails
    return [];
  }
}

List<Map<String, int>> convertSelectedUsersToReviewers(
  Map<int, List<Map<String, String>>> selectedUsersByReviewerType,
) {
  List<Map<String, int>> reviewers = [];

  // Iterate through each reviewer type and its list of users
  selectedUsersByReviewerType.forEach((flowReviewerTypeId, users) {
    for (var user in users) {
      // Extract user_id from the 'id' field and convert to int
      int? userId = int.tryParse(user['id'] ?? '');
      if (userId != null) {
        reviewers.add({
          'user_id': userId,
          'flow_reviewer_type_id': flowReviewerTypeId,
        });
      }
    }
  });

  return reviewers;
}

Map<DateTime, List<String>> convertToHolidaysMap(List<dynamic> jsonList) {
  final Map<DateTime, List<String>> holidays = {};

  for (var item in jsonList) {
    // Parse the date string to DateTime
    DateTime date = DateTime.parse(item['date']);
    // Get the name and store it as a single-item list
    String name = item['name'];
    holidays[DateTime(date.year, date.month, date.day)] = [name];
  }

  return holidays;
}

Map<String, dynamic> parseErrorResponse(dynamic responseData) {
  try {
    if (responseData == null) {
      return {};
    }

    // If it's already a Map<String, dynamic>
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    // If it's a Map but not the right type, convert it
    if (responseData is Map) {
      return Map<String, dynamic>.from(responseData);
    }

    // If it's a JSON string, try to decode it
    if (responseData is String) {
      final decoded = json.decode(responseData);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }

    // If none of the above worked, return empty map
    return {};
  } catch (e) {
    // If any parsing fails, return empty map
    return {};
  }
}

// AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']['request_category'])
// getSafeString(value: formatDate(data?['request']['end_datetime']))
