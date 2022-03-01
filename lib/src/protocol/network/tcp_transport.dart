import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../enums/session_encryption.enum.dart';
import '../enums/session_compression.enum.dart';
import '../envelope.dart';
import 'transport.dart';

import 'package:simple_logger/simple_logger.dart';
import 'package:pretty_json/pretty_json.dart';

class TCPTransport implements Transport {
  StreamController<Map<String, dynamic>>? stream =
      StreamController<Map<String, dynamic>>();
  WebSocket? socket;
  String? sessionId;

  @override
  StreamController<bool> onClose = StreamController<bool>();

  final logger = SimpleLogger();

  TCPTransport() {
    logger.setLevel(
      Level.INFO,
      includeCallerInfo: true,
    );
  }

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
    logger.info('Connected to: $uri');

    // listen for responses from the server
    socket?.listen(
      // handle data from the server
      (data) {
        final response = jsonDecode(data);

        logger.info('Envelope received: \n' + prettyJson(response, indent: 2));

        onEvelope?.add(response);
      },

      // handle errors
      onError: (error) {
        logger.shout('Error: $error');
        socket?.close();
      },

      // handle server ending connection
      onDone: () {
        logger.warning('Server closed the connection.');
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
  void send(Envelope envelope) {
    String encode = jsonEncode(envelope);

    ensureSocketOpen();

    socket?.add(encode);

    logger
        .info('Envelope send: \n' + prettyJson(jsonDecode(encode), indent: 2));
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
