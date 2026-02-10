extension DateTimeExtensions on DateTime {
  /// Returns a human-friendly relative string like "3 days ago".
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  /// Start of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Whether this date is the same calendar day as [other].
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
