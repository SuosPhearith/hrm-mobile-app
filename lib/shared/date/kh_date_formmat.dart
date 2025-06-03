class KhmerDateFormatter {
  static String format(DateTime date) {
    final Map<int, String> khmerMonths = {
      1: 'មករា',
      2: 'កុម្ភៈ',
      3: 'មីនា',
      4: 'មេសា',
      5: 'ឧសភា',
      6: 'មិថុនា',
      7: 'កក្កដា',
      8: 'សីហា',
      9: 'កញ្ញា',
      10: 'តុលា',
      11: 'វិច្ឆិកា',
      12: 'ធ្នូ',
    };
    final Map<int, String> khmerDigits = {
      0: '០',
      1: '១',
      2: '២',
      3: '៣',
      4: '៤',
      5: '៥',
      6: '៦',
      7: '៧',
      8: '៨',
      9: '៩',
    };

    String day = date.day
        .toString()
        .padLeft(2, '0')
        .split('')
        .map((d) => khmerDigits[int.parse(d)]!)
        .join();
    String month = khmerMonths[date.month]!;
    String year = date.year
        .toString()
        .split('')
        .map((d) => khmerDigits[int.parse(d)]!)
        .join();

    return '$day $month $year';
  }
}