import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../enums/session_encryption.enum.dart';
import '../enums/session_compression.enum.dart';
import '../envelope.dart';
import 'transport.dart';

class TCPTransport implements Transport {
  StreamController<Map<String, dynamic>>? stream =
      StreamController<Map<String, dynamic>>();
  WebSocket? socket;
  String? sessionId;

  @override
  StreamController<bool> onClose = StreamController<bool>();

  TCPTransport();

  @override
  Future<void> open(final String uri) async {
    if (uri.contains('wss://')) {
      encryption = SessionEncryption.tls;
    } else {
      encryption = SessionEncryption.none;
    }

    compression = SessionCompression.none;

    // connect to the socket server
    socket = await WebSocket.connect(uri, protocols: ['lime']);
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
  }

  @override
  Future<void> close() async {
    socket?.close();
    onClose.sink.add(true);
  }

  @override
  Future<void> send(Envelope envelope) async {
    String encode = jsonEncode(envelope);

    ensureSocketOpen();

    socket?.add(encode);
    print('message send: $encode\n');
  }

  Future<void> sendSecureMessage(
      SecureSocket socket, Map<String, dynamic> message) async {
    print('message send: $message\n');
    socket.add(utf8.encode(jsonEncode(message)));
    await Future.delayed(const Duration(seconds: 2));
  }

  void ensureSocketOpen() {
    if (socket?.readyState != WebSocket.open) {
      throw Exception('The connection is not open');
    }
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
