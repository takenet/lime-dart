export 'package:lime/src/protocol/extensions/notification_event.extension.dart';

enum NotificationEvent {
  /// The message was received and accepted by the server.
  /// This event is similar to the <see cref="Received"/> but is emitted by an intermediate node (hop) and not by the message's final destination.
  accepted,

  /// The message was dispatched to the destination by the server.
  /// This event is similar to the <see cref="Consumed"/> but is emitted by an intermediate node (hop) and not by the message's final destination.
  dispatched,

  /// The node has received the message.
  received,

  /// The node has consumed the content of the message.
  consumed,

  /// A problem occurred during the processing of the message.
  failed,

  /// The message is being sent
  sending,

  /// The message format was validated by the server.
  @Deprecated("This specific event should not be sent anymore")
  validated,

  /// The dispatch of the message was authorized by the server.
  @Deprecated("This specific event should not be sent anymore")
  authorized,

  unknown,
}
