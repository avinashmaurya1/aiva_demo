import 'package:intl/intl.dart';

/// Formatter for travel dates, flight times, and durations
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dayDateMonth = DateFormat('EEE, d MMM');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');

  /// Formats date to 'Mon, 10 Aug'
  static String formatTravelDate(DateTime date) {
    return _dayDateMonth.format(date);
  }

  /// Formats time to '06:30 AM'
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  /// Formats date to '2026-08-10'
  static String formatIso(DateTime date) {
    return _isoFormat.format(date);
  }

  /// Formats duration minutes to '2h 15m'
  static String formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
