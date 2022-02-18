import 'package:flutter/foundation.dart';
import '../protocol/enums/event.enum.dart';
import '../protocol/envelope.dart';
import '../protocol/node.dart';
import '../protocol/reason.dart';

class Notification extends Envelope {
  static const String eventKey = "event";
  static const String reasonKey = "reason";

  Notification(
      {final String? id,
      final Node? from,
      final Node? to,
      final Node? pp,
      this.event,
      this.reason})
      : super(id: id, from: from, to: to, pp: pp);

  /// Related event to the notification
  Event? event;

  /// In the case of a failed event, brings more details about the problem.
  Reason? reason;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> notification = {};

    if (id != null) {
      notification['id'] = id;
    }

    if (from != null) {
      notification['from'] = from.toString();
    }

    if (to != null) {
      notification['to'] = to.toString();
    }

    if (event != null) {
      notification[eventKey] = describeEnum(event!);
    }

    if (reason != null) {
      notification[reasonKey] = describeEnum(reasonKey);
    }

    return notification;
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    final envelope = Envelope.fromJson(json);

    final notification = Notification(
      id: envelope.id,
      from: envelope.from,
      to: envelope.to,
      pp: envelope.pp,
    );

    if (json.containsKey(reasonKey)) {
      notification.reason = Reason.fromJson(json[reasonKey]);
    }
    if (json.containsKey(eventKey)) {
      notification.event =
          Event.values.firstWhere((e) => describeEnum(e) == json[eventKey]);
    }

    return notification;
  }
}
