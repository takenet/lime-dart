import 'package:flutter/foundation.dart';

import 'document.dart';
import 'media_type.dart';
import 'enums/presence_status.enum.dart';
import 'enums/routing_rule.enum.dart';

class Presence extends Document {
  static const mimeType = "application/vnd.lime.presence+json";

  PresenceStatus? status;

  String? message;

  RoutingRule? routingRule;

  DateTime? lastSeen;

  int? priority;

  bool? filterByDistance;

  bool? roundRobin;

  bool? echo;

  bool? promiscuous;

  List<String>? instances;

  Presence({
    this.status,
    this.message,
    this.routingRule,
    this.lastSeen,
    this.priority,
    this.filterByDistance,
    this.roundRobin,
    this.echo,
    this.promiscuous,
    this.instances,
  }) : super(mediaType: MediaType.parse(mimeType));

  Map<String, dynamic> toJson() {
    Map<String, dynamic> presence = {};

    if (status != null) {
      presence['status'] = describeEnum(status!);
    }

    if (routingRule != null) {
      presence['routingRule'] = describeEnum(routingRule!);
    }

    return presence;
  }
}
