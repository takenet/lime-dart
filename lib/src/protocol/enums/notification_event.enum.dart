enum NotificationEvent {
  /// A problem occurred during the processing of the message.
  failed,

  /// The message was received and accepted by the server.
  /// This event is similar to the <see cref="Received"/> but is emitted by an intermediate node (hop) and not by the message's final destination.
  accepted,

  /// The message format was validated by the server.
  @Deprecated("This specific event should not be sent anymore")
  validated,

  /// The dispatch of the message was authorized by the server.
  @Deprecated("This specific event should not be sent anymore")
  authorized,

  /// The message was dispatched to the destination by the server.
  /// This event is similar to the <see cref="Consumed"/> but is emitted by an intermediate node (hop) and not by the message's final destination.
  dispatched,

  /// The node has received the message.
  received,

  /// The node has consumed the content of the message.
  consumed,

  unknown,
}

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
