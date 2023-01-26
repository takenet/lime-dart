import 'dart:async';

import '../command.dart';
import '../enums/session_state.enum.dart';
import '../message.dart';
import '../network/transport.dart';
import '../node.dart';
import '../notification.dart';
import '../security/authentication.dart';
import '../session.dart';

import 'channel.dart';

/// Defines a communication channel between a node and a server.
class ClientChannel extends Channel {
  ClientChannel(
    Transport transport, {
    final bool autoReplyPings = true,
    final bool autoNotifyReceipt = false,
  }) : super(
          transport: transport,
          autoReplyPings: autoReplyPings,
          autoNotifyReceipt: autoNotifyReceipt,
        );

  /// Exposes a [StreamController] to allow listening when a new [Notification] is received by the channel
  final onReceiveNotification = StreamController<Notification>();

  /// Exposes a [StreamController] to allow listening when a new [Command] is received by the channel
  final onReceiveCommand = StreamController<Command>();

  /// Exposes a [StreamController] to allow listening when a new [Message] is received by the channel
  final onReceiveMessage = StreamController<Message>();

  /// Exposes a [StreamController] to allow listening when a new [Session] with [SessionState.finished] type  is received by the channel
  final onSessionFinished = StreamController<Session>();

  /// Exposes a [StreamController] to allow listening when a new [Session] with [SessionState.failed] type is received by the channel
  final onSessionFailed = StreamController<Session>();

  /// Exposes a [StreamController] to allow listening when the server closes the connection
  var onConnectionDone = StreamController<bool>();

  /// A function that will be completed when  a [Session] of type [SessionState.authenticating] is received
  late Function(Session) _onSessionAuthenticating;

  /// A function that will be completed when  a [Session] of type [SessionState.authenticating] is received
  late Function(Session) _onSessionNegotiating;

  /// A function that will be completed when a [Session] of type [SessionState.established] is received
  late Function(Session) _onSessionEstablished;

  /// A function that will be completed when a [Session] of type [SessionState.finished] is received
  late Function(Session) _onSessionFinished;

  /// Establishes the session
  Future<Session> establishSession(
      String identity, String instance, Authentication authentication) async {
    Session session = await startNewSession();
    session = await authenticateSession(identity, instance, authentication);

    return session;
  }

  /// Send a [Session] type [Envelope] with state [SessionState.finishing] to end the communication
  Future<Session> sendFinishingSession() async {
    if (state != SessionState.established) {
      throw Exception('Cannot finish a session in the $state state');
    }

    final commandPromise = Future.any(
      [
        Future<Session>(() {
          final c = Completer<Session>();

          _onSessionFinished = (Session session) {
            if (session.state == SessionState.finished) {
              c.complete(session);
            } else {
              c.completeError('error - sendFinishingSession');
            }
          };

          return c.future;
        }),
        Future(() {
          final c = Completer<Session>();

          Future.delayed(const Duration(milliseconds: 6000), () {
            return c.completeError('Timeout reached - sendFinishingSession');
          });

          return c.future;
        }),
      ],
    );

    sendSession(
      Session(id: sessionId, state: SessionState.finishing),
    );

    return commandPromise;
  }

  /// Send a [Session] type [Envelope] with state [SessionState.isNew] to start the communication
  Future<Session> startNewSession() async {
    if (state != SessionState.isNew) {
      throw Exception('Cannot start a session in the $state state');
    }

    final commandPromise = Future.any(
      [
        Future<Session>(() {
          final c = Completer<Session>();

          _onSessionAuthenticating = (Session session) {
            if (session.state == SessionState.authenticating) {
              c.complete(session);
            } else {
              c.completeError('error - startNewSession');
            }
          };

          _onSessionNegotiating = (Session session) {
            if (session.state == SessionState.negotiating) {
              c.complete(session);
            } else {
              c.completeError('error - startNewSession');
            }
          };

          return c.future;
        }),
        Future(() {
          final c = Completer<Session>();

          Future.delayed(const Duration(milliseconds: 6000), () {
            return c.completeError('Timeout reached - startNewSession');
          });

          return c.future;
        }),
      ],
    );

    sendSession(Session(state: SessionState.isNew));
    return commandPromise;
  }

  /// Send a [Session] type [Envelope] with state [SessionState.authenticating] to start the authenticate
  Future<Session> authenticateSession(
      String identity, String instance, Authentication authentication) async {
    if (state != SessionState.authenticating) {
      throw Exception('Cannot authenticate a session in the $state state.');
    }

    final commandPromise = Future.any(
      [
        Future<Session>(() {
          final c = Completer<Session>();

          _onSessionEstablished = (Session session) {
            if (session.state == SessionState.established) {
              c.complete(session);
            } else {
              c.completeError('error - authenticateSession');
            }
          };

          return c.future;
        }),
        Future(() {
          final c = Completer<Session>();

          Future.delayed(const Duration(milliseconds: 6000), () {
            return c.completeError('Timeout reached - authenticateSession');
          });

          return c.future;
        }),
      ],
    );

    final session = Session(
      id: sessionId,
      from: Node.parse('$identity/$instance'),
      state: SessionState.authenticating,
      scheme: authentication.scheme,
      authentication: authentication,
    );

    sendSession(session);

    return commandPromise;
  }

  @override
  void onSession(session) {
    sessionId = session.id;
    state = session.state;
    if (session.state == SessionState.established) {
      localNode = session.to;
      remoteNode = session.from;
    }

    switch (session.state) {
      case SessionState.negotiating:
        _onSessionNegotiating(session);
        break;
      case SessionState.authenticating:
        _onSessionAuthenticating(session);
        break;
      case SessionState.established:
        _onSessionEstablished(session);
        break;
      case SessionState.finished:
        transport.close().then((value) {
          _onSessionFinished(session);
          onSessionFinished.sink.add(session);
        });
        break;
      case SessionState.failed:
        transport.close().then((value) {
          onSessionFailed.sink.add(session);
        });
        break;
      default:
    }
  }

  @override
  void onNotification(Notification notification) {
    onReceiveNotification.sink.add(notification);
  }

  @override
  void onCommand(Command command) {
    onReceiveCommand.sink.add(command);
  }

  @override
  void onMessage(Message message) {
    onReceiveMessage.sink.add(message);
  }

  @override
  void onCloseConnection(bool closed) {
    onConnectionDone.sink.add(closed);
  }
}
