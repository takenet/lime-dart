import 'package:flutter_test/flutter_test.dart';
import 'package:lime/lime.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'client_channel_test.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<WebSocketTransport>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
  ],
)
void main() {
  final mockWebSocketTransport = MockWebSocketTransport();

  ClientChannel clientChannel = ClientChannel(mockWebSocketTransport);

  group('startNewSession', () {
    test('should return a exception if state is not isNew', () {
      clientChannel.state = SessionState.authenticating;

      expect(clientChannel.startNewSession(), throwsException);
      verifyNever(mockWebSocketTransport.send(any));
    });
    test('should called the send at transport if session state is new', () {
      clientChannel.state = SessionState.isNew;

      clientChannel.startNewSession();
      verify(mockWebSocketTransport.send(any)).called(1);
    });
  });

  group('authenticateSession', () {
    test('should return a exception if state is not authenticating', () {
      clientChannel.state = SessionState.isNew;

      expect(
          clientChannel.authenticateSession('', '', ExternalAuthentication()),
          throwsException);
      verifyNever(mockWebSocketTransport.send(any));
    });
    test(
        'should called the send at transport if session state is authenticating',
        () {
      clientChannel.state = SessionState.authenticating;

      clientChannel.authenticateSession(
        'name@domain',
        'instance',
        ExternalAuthentication(
          token: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjRlY2RmZmV...',
          issuer: 'account.blip.ai',
        ),
      );
      verify(mockWebSocketTransport.send(any)).called(1);
    });
  });

  group('sendFinishingSession', () {
    test('should return a exception if state is not established', () {
      clientChannel.state = SessionState.isNew;

      expect(clientChannel.sendFinishingSession(), throwsException);
      verifyNever(mockWebSocketTransport.send(any));
    });
    test('should called the send at transport if session state is established',
        () {
      clientChannel.state = SessionState.established;

      clientChannel.sendFinishingSession();
      verify(mockWebSocketTransport.send(any)).called(1);
    });
  });
}
