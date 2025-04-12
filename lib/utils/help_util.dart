void printError({required String errorMessage, int? statusCode}) {
  final statusText = statusCode != null ? 'Status: $statusCode - ' : '';
  print('\x1B[31mError: $statusText$errorMessage\x1B[0m');
}

String formatTimeToHour(String? isoTimestamp) {
  try {
    // Parse the ISO 8601 string into a DateTime object
    DateTime dateTime = DateTime.parse(isoTimestamp ?? '');

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

Map<String, int> convertToHoursAndMinutes(double value) {
  int hours = value.floor();
  int minutes = ((value - hours) * 60).round();
  if (minutes == 60) {
    hours += 1;
    minutes = 0;
  }
  return {'hours': hours, 'minutes': minutes};
}

double clampToZeroOne(double value) {
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
