extension StringExtension on String {
  String trimEnd(String pattern) {
    int i = length;
    while (startsWith(pattern, i - pattern.length)) {
      i -= pattern.length;
    }
    return substring(0, i);
  }
}
