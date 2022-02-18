import '../command.dart';
import '../envelope.dart';
import '../media_type.dart';
import '../message.dart';
import '../node.dart';
import '../notification.dart';

extension EnvelopeExtension on Envelope {
  static const commandMimeType = 'application/vnd.lime.command+json';
  static const messageMimeType = 'application/vnd.lime.message+json';
  static const notificationMimeType = 'application/vnd.lime.notification+json';

  static final MediaType messageMediaType = MediaType.parse(messageMimeType);
  static final MediaType notificationMediaType =
      MediaType.parse(notificationMimeType);
  static final MediaType commandMediaType = MediaType.parse(commandMimeType);

  Message toMessage(envelope) =>
      toEnvelope(envelope, messageMediaType) as Message;
  Notification toNotification(envelope) =>
      toEnvelope(envelope, notificationMediaType) as Notification;
  Command toCommand(envelope) =>
      toEnvelope(envelope, commandMediaType) as Command;

  Envelope toEnvelope(Map<String, dynamic> mapDocument, MediaType mediaType) {
    return Envelope.fromJson(mapDocument);
  }

  /// Gets a shallow copy of the current Envelope.
  Envelope shallowCopy() {
    return Envelope(
      id: id,
      from: from,
      to: to,
      pp: pp,
      metadata: metadata,
    );
  }

  /// Gets the sender node of the envelope.
  Node? getSender() {
    return pp ?? from;
  }
}
