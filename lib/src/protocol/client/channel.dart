import 'dart:async';
import 'package:simple_logger/simple_logger.dart';

import '../command.dart';
import '../enums/command_method.enum.dart';
import '../enums/command_status.enum.dart';
import '../enums/session_state.enum.dart';
import '../envelope.dart';
import '../message.dart';
import '../network/transport.dart';
import '../node.dart';
import '../notification.dart';
import '../session.dart';

const commandTimeout = 6000;

abstract class Channel {
  final Transport transport;
  final bool autoReplyPings;
  final bool autoNotifyReceipt;

  Node? remoteNode;
  Node? localNode;
  String? sessionId;
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

    transport.onEvelope?.stream.listen(
      (event) {
        if (event.containsKey('state')) {
          logger.info('Received envelope is a Session');
          final session = Session.fromJson(event);
          onSession(session);
        } else if (event.containsKey('method')) {
          logger.info('Received envelope is a Command');
          final command = Command.fromJson(event);

          if (autoReplyPings &&
              command.id != null &&
              command.uri == '/ping' &&
              command.method == CommandMethod.get &&
              isForMe(command)) {
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

  Future<void> open(final String uri) async {
    await transport.open(uri);
  }

  void sendSession(Session session) {
    if (state == SessionState.finished || state == SessionState.failed) {
      throw Exception('Cannot send in the $state state');
    }
    send(session);
  }

  void sendCommand(Command command) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    send(command);
  }

  void sendNotification(Notification notification) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    send(notification);
  }

  void sendMessage(Message message) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    send(message);
  }

  send(Envelope envelope) {
    transport.send(envelope);
  }

  bool isForMe(Envelope envelope) {
    return envelope.to == null ||
        envelope.to.toString() == localNode?.toString() ||
        localNode
                ?.toString()
                .substring(0, envelope.to.toString().length)
                .toLowerCase() ==
            envelope.to.toString().toLowerCase();
  }

  void onMessage(Message message) {}
  void onSession(Session session) {}
  void onNotification(Notification notification) {}
  void onCommand(Command command) {}
}
