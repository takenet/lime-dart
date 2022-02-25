import 'media_type.dart';
import 'node.dart';

class Envelope {
  static const commandMimeType = 'application/vnd.lime.command+json';
  static const messageMimeType = 'application/vnd.lime.message+json';
  static const notificationMimeType = 'application/vnd.lime.notification+json';

  static final MediaType commandMediaType = MediaType.parse(commandMimeType);
  static final MediaType messageMediaType = MediaType.parse(messageMimeType);
  static final MediaType notificationMediaType = MediaType.parse(notificationMimeType);

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

  factory Envelope.fromJson(Map<String, dynamic> json) {
    return Envelope(
        id: json.containsKey('id') ? json['id'] : null,
        from: json.containsKey('from') ? Node.parse(json['from']) : null,
        to: json.containsKey('to') ? Node.parse(json['to']) : null,
        pp: json.containsKey('pp') ? Node.parse(json['pp']) : null,
        metadata: json.containsKey('metadata') ? Map<String, String>.from(json['metadata']) : null);
  }
}
