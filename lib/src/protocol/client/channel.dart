import 'dart:async';

import '../command.dart';
import '../enums/command_method.enum.dart';
import '../enums/command_status.enum.dart';
import '../enums/session_state.enum.dart';
import '../envelope.dart';
import '../message.dart';
import '../network/transport.dart';
import '../notification.dart';
import '../session.dart';

const commandTimeout = 6000;

abstract class Channel {
  final Transport transport;
  final bool autoReplyPings;
  final bool autoNotifyReceipt;

  String? remoteNode;
  String? localNode;
  String? sessionId;
  SessionState? state;

  Channel({
    required this.transport,
    required this.autoReplyPings,
    required this.autoNotifyReceipt,
  }) {
    state = SessionState.isNew;

    transport.onEvelope?.stream.listen(
      (event) {
        print('event received on channel: $event\n');

        if (event.containsKey('state')) {
          print('envelope is session');
          final session = Session.fromJson(event);
          onSession(session);
        } else if (event.containsKey('method')) {
          print('envelope is command');
          final command = Command.fromJson(event);

          if (autoReplyPings &&
              command.id != null &&
              command.uri == '/ping' &&
              command.method == CommandMethod.get &&
              _isForMe(command)) {
            print('auto reply ping');

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
          print('envelope is message');
          final message = Message.fromJson(event);
          onMessage(message);
        } else if (event.containsKey('event')) {
          print('envelope is notification');
          final notification = Notification.fromJson(event);
          onNotification(notification);
        }

        print('\n-------------------------------------------------------\n');
      },
      onError: (e) => print('stream error: $e'),
      onDone: () => print('stream done'),
    );
  }

  Future<void> open(final String uri) async {
    await transport.open(uri);
  }

  Future<void> sendSession(Session session) {
    if (state == SessionState.finished || state == SessionState.failed) {
      throw Exception('Cannot send in the $state state');
    }
    return send(session);
  }

  // Future processCommand(Command command, {int timeout = commandTimeout}) {
  //   final responsePromise = Future<Command>(() {
  //     final _completer = Completer<Command>();
  //     _commandResolves[command.id] = _completer.complete;

  //     return _completer.future;
  //   });

  //   final commandPromise = Future<Command>.any([
  //     responsePromise,
  //     Future<Command>(() {
  //       final _completer = Completer<Command>();

  //       Future.delayed(
  //         Duration(milliseconds: timeout),
  //         () {
  //           if (_commandResolves[command.id] == null) return _completer.future;

  //           _commandResolves.remove(command.id);

  //           final cmd = jsonEncode(command);
  //           return Future.error(Exception('The follow command processing has timed out: $cmd'));
  //         },
  //       );
  //     }),
  //   ]);

  //   sendCommand(command);
  //   return commandPromise;
  // }

  Future<void> sendCommand(Command command) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    return send(command);
  }

  Future<void> sendNotification(Notification notification) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    return send(notification);
  }

  Future<void> sendMessage(Message message) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    return send(message);
  }

  send(Envelope envelope) async {
    await transport.send(envelope);
  }

  bool _isForMe(Envelope envelope) {
    return envelope.to == null ||
        envelope.to.toString() == localNode ||
        localNode!.substring(0, envelope.to.toString().length) ==
            envelope.to.toString();
  }

  void onMessage(Message message) {}
  void onSession(Session session) {}
  void onNotification(Notification notification) {}
  void onCommand(Command command) {}
}
