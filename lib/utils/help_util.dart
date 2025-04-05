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
