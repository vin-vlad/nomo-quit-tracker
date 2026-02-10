import 'package:intl/intl.dart';

/// Formatting utilities.
class Formatters {
  Formatters._();

  /// Format a date as "Jan 15, 2026".
  static String date(DateTime dt) => DateFormat.yMMMd().format(dt);

  /// Format a date as "Jan 15, 2026 at 3:30 PM".
  static String dateTime(DateTime dt) => DateFormat.yMMMd().add_jm().format(dt);

  /// Format a time as "3:30 PM".
  static String time(DateTime dt) => DateFormat.jm().format(dt);

  /// Format a compact date as "01/15".
  static String dateCompact(DateTime dt) => DateFormat('MM/dd').format(dt);
}
