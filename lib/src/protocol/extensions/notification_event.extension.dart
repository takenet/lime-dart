import 'package:flutter/foundation.dart';

import '../enums/notification_event.enum.dart';

extension NotificationEventExtension on NotificationEvent {
  NotificationEvent getValue(String value) =>
      NotificationEvent.values.firstWhere((e) => describeEnum(e) == value, orElse: () => NotificationEvent.unknown);
}
