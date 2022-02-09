import 'package:lime/network/transport.dart';
import 'package:lime/protocol/command.dart';
import 'package:lime/protocol/enums/session_state.enum.dart';
import 'package:lime/protocol/envelope.dart';
import 'package:lime/protocol/message.dart';
import 'package:lime/protocol/notification.dart';
import 'package:lime/protocol/session.dart';

abstract class Channel {
  final Transport transport;
  final bool autoReplyPings;
  final bool autoNotifyReceipt;
  //var _commandResolves = {};

  String? remoteNode;
  String? localNode;
  String? sessionId;
  SessionState? state;

  Channel({
    required this.transport,
    this.autoReplyPings = false,
    this.autoNotifyReceipt = false,
  }) {
    state = SessionState.isNew;

    transport.onEvelope?.stream.listen(
      (event) {
        print('event received on channel: $event\n');

        if (event.containsKey('state')) {
          print('envelope is session');
          Session session = Session.fromJson(event);
          onSession(session);
        } else if (event.containsKey('method')) {
          print('envelope is method');
        } else if (event.containsKey('content')) {
          print('envelope is message');
        } else if (event.containsKey('event')) {
          print('envelope is notification');
        }

        print('\n-------------------------------------------------------\n');
      },
      onError: (e) => print('stream error: $e'),
      onDone: () => print('stream done'),
    );
  }

  Future<void> open() async {
    await transport.open();
  }

  Future<void> sendSession(Session session) {
    if (state == SessionState.finished || state == SessionState.failed) {
      throw Exception('Cannot send in the $state state');
    }
    return send(session);
  }

  Future<void> sendCommand(Command command) {
    if (state != SessionState.established) {
      throw Exception('Cannot send in the $state state');
    }
    return send(command);
  }

  send(Envelope envelope) async {
    await transport.send(envelope);
  }

  void onMessage(Message message) {}
  void onSession(Session session) {}
  void onNotification(Notification notification) {}
  void onCommand(Command command) {}
}
