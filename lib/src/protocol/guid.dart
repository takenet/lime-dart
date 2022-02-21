import 'dart:math';

String guid() {
  var d = DateTime.now().millisecondsSinceEpoch;

  final uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(RegExp(r'[xy]', multiLine: true), (match) {
    final c = match.group(0);

    final r = ((d + Random().nextDouble() * 16) % 16).floor();
    d = (d / 16).floor();
    return (c == 'x' ? r : (r & 0x3 | 0x8)).toRadixString(16);
  });

  return uuid;
}
