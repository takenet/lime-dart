import 'package:lime/protocol/envelope.dart';

import 'package:lime/protocol/node.dart';

class Message extends Envelope {
  static const String typeKey = 'type';
  static const String contentKey = 'content';

  /// Initializes a new instance of the Message class.
  Message(
      {final String? id,
      final Node? from,
      final Node? to,
      final Node? pp,
      this.content,
      this.type})
      : super(id: id, from: from, to: to, pp: pp);

  ///  MIME declaration of the content type of the message.
  String? type;

  /// Message body content
  dynamic content;

  factory Message.fromJson(Map<String, dynamic> json) {
    final message = Message(
      id: json.containsKey('id') ? json['id'] : null,
      from: json.containsKey('from') ? Node.parse(json['from']) : null,
      to: json.containsKey('to') ? Node.parse(json['to']) : null,
      pp: json.containsKey('pp') ? Node.parse(json['pp']) : null,
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
