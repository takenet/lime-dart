import 'guid.dart';
import 'media_type.dart';
import 'node.dart';

class Envelope {
  static const commandMimeType = 'application/vnd.lime.command+json';
  static const messageMimeType = 'application/vnd.lime.message+json';
  static const notificationMimeType = 'application/vnd.lime.notification+json';

  static final MediaType commandMediaType = MediaType.parse(commandMimeType);
  static final MediaType messageMediaType = MediaType.parse(messageMimeType);
  static final MediaType notificationMediaType =
      MediaType.parse(notificationMimeType);

  static const String idKey = 'id';
  static const String fromKey = 'from';
  static const String toKey = 'to';
  static const String ppKey = 'pp';
  static const String metadataKey = 'metadata';

  final String id;
  Node? from;
  Node? to;
  Node? pp;
  Map<String, dynamic>? metadata;

  Envelope({
    required this.id,
    this.from,
    this.to,
    this.pp,
    this.metadata,
  });

  /// Allows converting a collection of key/value pairs, [Map] to a [Envelope] object
  factory Envelope.fromJson(Map<String, dynamic> json) {
    return Envelope(
        id: json.containsKey(idKey) ? json[idKey] : guid(),
        from: json.containsKey(fromKey) ? Node.parse(json[fromKey]) : null,
        to: json.containsKey(toKey) ? Node.parse(json[toKey]) : null,
        pp: json.containsKey(ppKey) ? Node.parse(json[ppKey]) : null,
        metadata: json.containsKey(metadataKey)
            ? Map<String, String>.from(json[metadataKey])
            : null);
  }
}
