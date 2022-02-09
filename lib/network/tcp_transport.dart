import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lime/protocol/enums/session_encryption.enum.dart';
import 'package:lime/protocol/enums/session_compression.enum.dart';
import 'package:lime/protocol/envelope.dart';
import 'transport.dart';

class TCPTransport implements Transport {
  final String uri;
  StreamController<Map<String, dynamic>>? stream =
      StreamController<Map<String, dynamic>>();
  WebSocket? socket;
  String? sessionId;

  TCPTransport({required this.uri});

  @override
  Future<void> open() async {
    if (uri.contains('wss://')) {
      encryption = SessionEncryption.tls;
    } else {
      encryption = SessionEncryption.none;
    }

    compression = SessionCompression.none;

    // connect to the socket server
    socket = await WebSocket.connect('wss://$uri', protocols: ['lime']);
    print('Connected to: hmg-ws.blip.ai:443');

    // listen for responses from the server
    socket?.listen(
      // handle data from the server
      (data) {
        final response = jsonDecode(data);
        //sessionId = response['id'];

        print(
          'message received: $response',
        );
        print('\n-------------------------------------------------------\n');

        onEvelope?.add(response);
      },

      // handle errors
      onError: (error) {
        print('error: $error');
        socket?.close();
      },

      // handle server ending connection
      onDone: () {
        print('Server closed the connection.');
        socket?.close();
      },
    );

    //testes
    //await Future.delayed(Duration(seconds: 2));
    //await send({'state': 'new'});
    //await send(Session(state: SessionState.isNew));

    //await Future.delayed(Duration(seconds: 2));
    // await send({
    //   "id": sessionId,
    //   "from": "boris@msging.net",
    //   "state": "authenticating",
    //   "scheme": "key",
    //   "authentication": {"key": "ZTQ3UTdiR1pEMXNSV0ROc2t2UEc="}
    // });

    //final keyAuthentication = KeyAuthentication();
    //keyAuthentication.key = 'ZTQ3UTdiR1pEMXNSV0ROc2t2UEc=';

    // Session envelopeSession = Session(
    //     id: sessionId,
    //     from: Node(name: 'boris', domain: 'msging.net'),
    //     state: SessionState.authenticating,
    //     scheme: AuthenticationScheme.key,
    //     authentication: keyAuthentication);
    //await send(envelopeSession);
  }

  @override
  Future<void> close() async {
    socket?.close();
  }

  @override
  Future<void> send(Envelope message) async {
    String encode = jsonEncode(message);

    socket?.add(encode);
    print('message send: $encode\n');
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> sendSecureMessage(
      SecureSocket socket, Map<String, dynamic> message) async {
    print('message send: $message\n');
    socket.add(utf8.encode(jsonEncode(message)));
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  get onEvelope => stream;

  @override
  set onEvelope(StreamController<Map<String, dynamic>>? _onEvelope) {
    stream = _onEvelope;
  }

  @override
  SessionCompression? compression;

  @override
  SessionEncryption? encryption;
}
