import 'package:intl/intl.dart';

class CustomFormat {
  static String formatTime(DateTime? date) {
    try {
      if (date != null) {
        return DateFormat.jm().format(date);
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  static String formatDate(DateTime? date) {
    try {
      if (date != null) {
        return DateFormat('yyy-MM-dd').format(date);
      }
      return "";
    } catch (e) {
      return "";
    }
  }
}
