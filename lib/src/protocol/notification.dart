import 'package:flutter/foundation.dart';
import 'enums/notification_event.enum.dart';
import 'envelope.dart';
import 'envelope_id.dart';
import 'node.dart';
import 'reason.dart';

class Notification extends Envelope {
  static const String eventKey = "event";
  static const String reasonKey = "reason";

  Notification(
      {final String? id,
      final Node? from,
      final Node? to,
      final Node? pp,
      final Map<String, String>? metadata,
      this.event,
      this.reason})
      : super(id: id ?? EnvelopeId.newId(), from: from, to: to, pp: pp, metadata: metadata);

  /// Related event to the notification
  NotificationEvent? event;

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
      metadata: envelope.metadata,
    );

    if (json.containsKey(reasonKey)) {
      notification.reason = Reason.fromJson(json[reasonKey]);
    }
    if (json.containsKey(eventKey)) {
      notification.event = NotificationEvent.values
          .firstWhere((e) => describeEnum(e) == json[eventKey]);
    }

    return notification;
  }
}
