import 'dart:async';

import 'package:lime/network/transport.dart';
import 'package:lime/protocol/enums/session_state.enum.dart';
import 'package:lime/protocol/node.dart';
import 'package:lime/protocol/session.dart';
import 'package:lime/security/enums/authentication_scheme.enum.dart';
import 'package:lime/security/key_authentication.dart';

import 'channel.dart';

class ClientChannel extends Channel {
  ClientChannel(Transport transport) : super(transport: transport);

  StreamController<Session>? sessionEstablishedStream =
      StreamController<Session>();

  StreamController<Session>? sessionAuthenticationStream =
      StreamController<Session>();

  StreamController<Session>? sessionFinishedStream =
      StreamController<Session>();

  Future<void> establishSession() async {
    Session session;
    print('start startNewSession');
    session = await startNewSession();
    print('end startNewSession');

    print('start authenticateSession');
    session = await authenticateSession();
    print('end authenticateSession');
  }

  Future<Session> sendFinishingSession() async {
    if (state != SessionState.established) {
      throw Exception('Cannot finish a session in the $state state');
    }

    Session session = Session(id: sessionId, state: SessionState.finishing);
    sendSession(session);

    await for (Session value in sessionFinishedStream!.stream) {
      return value;
    }

    throw Exception('sendFinishingSession error');
  }

  Future<Session> startNewSession() async {
    if (state != SessionState.isNew) {
      throw Exception('Cannot start a session in the $state state');
    }

    Session session = Session(state: SessionState.isNew);
    sendSession(session);

    await for (Session value in sessionEstablishedStream!.stream) {
      return value;
    }

    throw Exception('startNewSession error');
  }

  Future<Session> authenticateSession() async {
    if (state != SessionState.authenticating) {
      throw Exception('Cannot authenticate a session in the $state state.');
    }

    //TODO: review static params
    final keyAuthentication = KeyAuthentication();
    keyAuthentication.key = 'ZTQ3UTdiR1pEMXNSV0ROc2t2UEc=';
    Session session = Session(
      id: sessionId,
      from: Node(name: 'boris', domain: 'msging.net'),
      state: SessionState.authenticating,
      scheme: AuthenticationScheme.key,
      authentication: keyAuthentication,
    );

    sendSession(session);

    await for (Session value in sessionAuthenticationStream!.stream) {
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
        sessionEstablishedStream?.sink.add(session);
        break;
      case SessionState.established:
        print('onSession - established');
        sessionAuthenticationStream?.sink.add(session);
        break;
      case SessionState.finished:
        print('onSession - finished');
        sessionFinishedStream?.sink.add(session);
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
