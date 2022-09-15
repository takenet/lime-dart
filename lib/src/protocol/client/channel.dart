import 'dart:async';
import 'package:simple_logger/simple_logger.dart';

import '../command.dart';
import '../enums/command_method.enum.dart';
import '../enums/command_status.enum.dart';
import '../enums/session_state.enum.dart';
import '../enums/notification_event.enum.dart';
import '../envelope.dart';
import '../message.dart';
import '../network/transport.dart';
import '../node.dart';
import '../notification.dart';
import '../session.dart';

const commandTimeout = 6000;

/// Base class for the protocol communication channels.
abstract class Channel {
  /// The current session transport
  final Transport transport;

  /// Allows automatically responding to ping commands
  final bool autoReplyPings;

  /// Allows automatically notify receipt
  final bool autoNotifyReceipt;

  /// Remote node identifier
  Node? remoteNode;

  /// Local node identifier
  Node? localNode;

  /// The session Id
  String? sessionId;

  /// Current session state
  SessionState? state;

  final logger = SimpleLogger();

  Channel({
    required this.transport,
    required this.autoReplyPings,
    required this.autoNotifyReceipt,
  }) {
    logger.setLevel(
      Level.INFO,
      includeCallerInfo: true,
    );

    state = SessionState.isNew;

    // Start listening to the stream
    transport.onEnvelope?.stream.listen(
      (event) {
        if (event.containsKey('state')) {
          logger.info('Received envelope is a Session');
          final session = Session.fromJson(event);
          onSession(session);
        } else if (event.containsKey('method')) {
          logger.info('Received envelope is a Command');
          final command = Command.fromJson(event);

          if (autoReplyPings && command.uri == '/ping' && command.method == CommandMethod.get && isForMe(command)) {
            logger.info('Auto reply ping..');

            final commandSend = Command(
              id: command.id,
              to: command.from,
              method: CommandMethod.get,
              status: CommandStatus.success,
              type: 'application/vnd.lime.ping+json',
              resource: {},
            );

            sendCommand(commandSend);
          }

          onCommand(command);
        } else if (event.containsKey('content')) {
          logger.info('Received envelope is a Message');
          final message = Message.fromJson(event);
          _notifyMessage(message);
          onMessage(message);
        } else if (event.containsKey('event')) {
          logger.info('Received envelope is a Notification');
          final notification = Notification.fromJson(event);
          onNotification(notification);
        }
      },
      onError: (e) => logger.shout('stream error: $e'),
      onDone: () => logger.info('stream done'),
    );
  }

  /// Open the connection with the transport
  Future<void> open(final String uri) async {
    await transport.open(uri);
  }

  /// Allows sending a [Session] of type [Envelope]
  void sendSession(Session session) {
    if (state == SessionState.finished || state == SessionState.failed) {
      throw Exception('Cannot send in the $state state');
    }
    send(session);
  }

  /// Allows sending a [Command] of type [Envelope]
  void sendCommand(Command command) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    send(command);
  }

  /// Allows sending a [Notification] of type [Envelope]
  void sendNotification(Notification notification) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    send(notification);
  }

  /// Allows sending a [Message] of type [Envelope]
  void sendMessage(Message message) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    send(message);
  }

  /// Allows sending a [Envelope]
  send(Envelope envelope) {
    transport.send(envelope);
  }

  void _notifyMessage(Message message) {
    if (autoNotifyReceipt && message.from != null && isForMe(message)) {
      final notification = Notification(
        id: message.id,
        to: message.from,
        event: NotificationEvent.received,
      );

      sendNotification(notification);
    }
  }

  bool isForMe(Envelope envelope) {
    return envelope.to == null ||
        envelope.to.toString() == localNode?.toString() ||
        localNode?.toString().substring(0, envelope.to.toString().length).toLowerCase() ==
            envelope.to.toString().toLowerCase();
  }

  /// A function that will be executed when an [Envelope] of type [Message] is received by the [Transport] layer
  void onMessage(Message message) {}

  /// A function that will be executed when an [Envelope] of type [Session] is received by the [Transport] layer
  void onSession(Session session) {}

  /// A function that will be executed when an [Envelope] of type [Notification] is received by the [Transport] layer
  void onNotification(Notification notification) {}

  /// A function that will be executed when an [Envelope] of type [Command] is received by the [Transport] layer
  void onCommand(Command command) {}
}
