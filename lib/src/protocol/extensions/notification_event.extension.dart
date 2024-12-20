import '../enums/notification_event.enum.dart';

extension NotificationEventExtension on NotificationEvent {
  NotificationEvent getValue(String? value) =>
      NotificationEvent.values.firstWhere((e) => e.name == value,
          orElse: () => NotificationEvent.unknown);

  bool isLowerThan(NotificationEvent? other) {
    const events = {
      NotificationEvent.sending: 0,
      NotificationEvent.accepted: 1,
      NotificationEvent.dispatched: 2,
      NotificationEvent.received: 3,
      NotificationEvent.consumed: 4,
      NotificationEvent.failed: 5,
      NotificationEvent.unknown: 99,
    };

    return (events[this] ?? 99) <
        (events[other ?? NotificationEvent.unknown] ?? 99);
  }
}
