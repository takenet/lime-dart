import 'envelope.dart';
import 'guid.dart';

/// Provides the transport of a content between nodes in a network.
class Message extends Envelope {
  static const String typeKey = 'type';
  static const String contentKey = 'content';

  /// Initializes a new instance of the Message class.
  Message({
    final String? id,
    super.from,
    super.to,
    super.pp,
    super.metadata,
    this.content,
    this.type,
  }) : super(id: id ?? guid());

  ///  MIME declaration of the content type of the message.
  String? type;

  /// Message body content
  dynamic content;

  /// Allows converting a collection of key/value pairs, [Map] to a [Message] object
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

  /// Allows converting a [Message] object to a [Map] collection of key/value pairs
  Map<String, dynamic> toJson() {
    Map<String, dynamic> message = {};

    message[Envelope.idKey] = id;

    if (from != null) {
      message[Envelope.fromKey] = from.toString();
    }

    if (to != null) {
      message[Envelope.toKey] = to.toString();
    }

    if (pp != null) {
      message[Envelope.ppKey] = pp.toString();
    }

    if (metadata != null) {
      message[Envelope.metadataKey] = metadata;
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
