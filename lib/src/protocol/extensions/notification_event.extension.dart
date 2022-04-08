import '../enums/notification_event.enum.dart';

extension NotificationEventExtension on NotificationEvent {
  NotificationEvent getValue(String stringValue) {
    NotificationEvent value;

    switch (stringValue.toLowerCase()) {
      case 'failed':
        value = NotificationEvent.failed;
        break;
      case 'accepted':
        value = NotificationEvent.accepted;
        break;
      case 'validated':
        value = NotificationEvent.validated;
        break;
      case 'authorized':
        value = NotificationEvent.authorized;
        break;
      case 'dispatched':
        value = NotificationEvent.dispatched;
        break;
      case 'received':
        value = NotificationEvent.received;
        break;
      case 'consumed':
        value = NotificationEvent.consumed;
        break;
      default:
        value = NotificationEvent.unknown;
    }

    return value;
  }
}
