import 'package:intl/intl.dart';

extension TodoDateTimeFormatter on DateTime {
  // Formats date and time based on today's date
  String format() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm'); // Format time (hours:minutes)

    if (year == now.year && month == now.month && day == now.day) {
      // Today
      return formatter.format(this);
    } else if (year == now.year && month == now.month && day == now.day - 1) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Other dates
      return DateFormat('dd MMM yyyy').format(this);
    }
  }
}
