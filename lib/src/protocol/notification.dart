import 'package:flutter/foundation.dart';
import 'enums/notification_event.enum.dart';
import 'envelope.dart';
import 'guid.dart';
import 'node.dart';
import 'reason.dart';

/// Transports information about events associated to a message in a session.
/// Can be originated by a server or by the message destination node.
class Notification extends Envelope {
  static const String eventKey = "event";
  static const String reasonKey = "reason";

  Notification({
    final String? id,
    final Node? from,
    final Node? to,
    final Node? pp,
    final Map<String, dynamic>? metadata,
    this.event,
    this.reason,
  }) : super(id: id ?? guid(), from: from, to: to, pp: pp, metadata: metadata);

  /// Related event to the notification
  NotificationEvent? event;

  /// In the case of a failed event, brings more details about the problem.
  Reason? reason;

  /// Allows converting a [Notification] object to a [Map] collection of key/value pairs
  Map<String, dynamic> toJson() {
    Map<String, dynamic> notification = {};

    notification[Envelope.idKey] = id;

    if (from != null) {
      notification[Envelope.fromKey] = from.toString();
    }

    if (to != null) {
      notification[Envelope.toKey] = to.toString();
    }

    if (pp != null) {
      notification[Envelope.ppKey] = pp.toString();
    }

    if (metadata != null) {
      notification[Envelope.metadataKey] = metadata;
    }

    if (event != null) {
      notification[eventKey] = describeEnum(event!);
    }

    if (reason != null) {
      notification[reasonKey] = reason?.toJson();
    }

    return notification;
  }

  /// Allows converting a collection of key/value pairs, [Map] to a [Notification] object
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
