import 'dart:typed_data';

class JsonBufferReadResult {
  final bool success;
  final Uint8List? jsonBytes;

  JsonBufferReadResult({required this.success, this.jsonBytes});
}
