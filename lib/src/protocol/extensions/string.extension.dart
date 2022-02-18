import 'dart:convert' show utf8, base64;

extension StringExtension on String {
  String trimEnd(String pattern) {
    int i = length;
    while (startsWith(pattern, i - pattern.length)) {
      i -= pattern.length;
    }
    return substring(0, i);
  }

  /// Gets a Base64 representation of a string
  String toBase64() {
    if (isEmpty) throw ArgumentError.notNull('value');

    return base64.encode(utf8.encode(this));
  }

  /// Converts from a Base64 string
  String fromBase64() {
    if (isEmpty) throw ArgumentError.notNull('value');

    return utf8.decode(base64.decode(this));
  }
}
