import 'dart:async';

import 'package:lime/network/transport.dart';
import 'package:lime/protocol/enums/session_state.enum.dart';
import 'package:lime/protocol/node.dart';
import 'package:lime/protocol/session.dart';
import 'package:lime/security/authentication.dart';

import 'channel.dart';

class ClientChannel extends Channel {
  ClientChannel(Transport transport) : super(transport: transport);

  final _sessionEstablishedStream = StreamController<Session>();
  final _sessionAuthenticationStream = StreamController<Session>();
  final _sessionFinishedStream = StreamController<Session>();

  Future<void> establishSession(
      String identity, String instance, Authentication authentication) async {
    Session session = await startNewSession();

    session = await authenticateSession(identity, instance, authentication);
  }

  Future<Session> sendFinishingSession() async {
    if (state != SessionState.established) {
      throw Exception('Cannot finish a session in the $state state');
    }

    sendSession(
      Session(id: sessionId, state: SessionState.finishing),
    );

    await for (Session value in _sessionFinishedStream.stream) {
      return value;
    }

    throw Exception('sendFinishingSession error');
  }

  Future<Session> startNewSession() async {
    if (state != SessionState.isNew) {
      throw Exception('Cannot start a session in the $state state');
    }

    sendSession(Session(state: SessionState.isNew));

    await for (Session value in _sessionEstablishedStream.stream) {
      return value;
    }

    throw Exception('startNewSession error');
  }

  Future<Session> authenticateSession(
      String identity, String instance, Authentication authentication) async {
    if (state != SessionState.authenticating) {
      throw Exception('Cannot authenticate a session in the $state state.');
    }

    final session = Session(
      id: sessionId,
      from: Node.parse('$identity/$instance'),
      state: SessionState.authenticating,
      scheme: authentication.scheme,
      authentication: authentication,
    );

    sendSession(session);

    await for (Session value in _sessionAuthenticationStream.stream) {
      return value;
    }
    throw Exception('authenticateSession error');
  }

  @override
  void onSession(session) {
    sessionId = session.id;
    state = session.state;
    if (session.state == SessionState.established) {
      localNode = session.to.toString();
      remoteNode = session.from.toString();
    }

    switch (session.state) {
      case SessionState.authenticating:
        print('onSession - authenticating');
        _sessionEstablishedStream.sink.add(session);
        break;
      case SessionState.established:
        print('onSession - established');
        _sessionAuthenticationStream.sink.add(session);
        break;
      case SessionState.finished:
        print('onSession - finished');
        _sessionFinishedStream.sink.add(session);
        break;
      default:
    }
  }

  @override
  void onNotification(notification) {}
  @override
  void onCommand(command) {}
  @override
  void onMessage(message) {}
}
