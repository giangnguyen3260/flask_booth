import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateTime emptyDate = DateTime(0, 0, 0);

  static DateTime parse({
    required String date,
  }) {
    if (date.isEmpty) {
      return emptyDate;
    }
    return DateTime.tryParse(date) ?? emptyDate;
  }

  static String format({
    required DateTime date,
    String format = "yyyyMMdd",
  }) {
    // Create a DateFormat object with the desired format
    final DateFormat formatter = DateFormat(format);

    // Format the DateTime object to the desired string format
    return formatter.format(date);
  }
}
