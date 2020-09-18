import 'package:intl/intl.dart';

class DateFormatter {

  static String formatDate(String format, DateTime date) {
    return DateFormat(format).format(date);
  }

}