import 'package:flutter/foundation.dart';

import '../enums/notification_event.enum.dart';

extension NotificationEventExtension on NotificationEvent {
  NotificationEvent getValue(String? value) =>
      NotificationEvent.values.firstWhere((e) => describeEnum(e) == value, orElse: () => NotificationEvent.unknown);

  bool isLowerThan(NotificationEvent? other) {
    const events = {
      NotificationEvent.accepted: 0,
      NotificationEvent.dispatched: 1,
      NotificationEvent.received: 2,
      NotificationEvent.consumed: 3,
      NotificationEvent.failed: 4,
      NotificationEvent.unknown: 99,
    };

    return (events[this] ?? 99) < (events[other ?? NotificationEvent.unknown] ?? 99);
  }
}
