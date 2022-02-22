import 'envelope.dart';
import 'node.dart';

class Message extends Envelope {
  static const String typeKey = 'type';
  static const String contentKey = 'content';

  /// Initializes a new instance of the Message class.
  Message(
      {final String? id,
      final Node? from,
      final Node? to,
      final Node? pp,
      final Map<String, String>? metadata,
      this.content,
      this.type})
      : super(id: id, from: from, to: to, pp: pp, metadata: metadata);

  ///  MIME declaration of the content type of the message.
  String? type;

  /// Message body content
  dynamic content;

  factory Message.fromJson(Map<String, dynamic> json) {
    final envelope = Envelope.fromJson(json);

    final message = Message(
      id: envelope.id,
      from: envelope.from,
      to: envelope.to,
      pp: envelope.pp,
      metadata: envelope.metadata,
    );

    if (json.containsKey(contentKey)) {
      message.content = json[contentKey];
    }
    if (json.containsKey(typeKey)) {
      message.type = json[typeKey];
    }

    return message;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> message = {};

    if (id != null) {
      message['id'] = id;
    }

    if (from != null) {
      message['from'] = from.toString();
    }

    if (to != null) {
      message['to'] = to.toString();
    }

    if (content != null) {
      message[contentKey] = content;
    }

    if (type != null) {
      message[typeKey] = type;
    }

    return message;
  }
}
