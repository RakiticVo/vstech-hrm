/// Extension on nullable [String] for formatting ISO date strings.
extension DateFormatterExtension on String? {
  /// Formats date strings containing ISO timestamps (`YYYY-MM-DD` or `YYYY-MM-DDT...`) to `dd-MM-yyyy`.
  /// Leaves non-matching date formats untouched.
  String toDisplayDate() {
    final str = this;
    if (str == null || str.trim().isEmpty) return '';
    return str.replaceAllMapped(
      RegExp(r'(\d{4})-(\d{2})-(\d{2})(?:T[\d:.]+)?'),
      (match) => '${match.group(3)}-${match.group(2)}-${match.group(1)}',
    );
  }
}
