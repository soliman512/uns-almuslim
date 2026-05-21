import 'package:intl/intl.dart';

class DateManager {
  // Converts DateTime to a String like "6:20"
  static String getFormattedTime(DateTime time) {
    // 'ar' ensures the numbers are Arabic (٦:٢٠)
    return DateFormat('h:mm').format(time);
  }

  // Decision maker: Returns true if between 4 AM and 12 PM
  static bool isMorning() {
    int hour = DateTime.now().hour;
    return hour >= 4 && hour < 16;
  }
}
