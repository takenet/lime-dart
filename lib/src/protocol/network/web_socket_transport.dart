import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import '../../services/logger.service.dart';
import '../../utils/lime.utils.dart';
import '../enums/session_encryption.enum.dart';
import '../enums/session_compression.enum.dart';
import '../envelope.dart';
import '../exceptions/insecure_socket.exception.dart';
import 'transport.dart';

import 'package:pretty_json/pretty_json.dart';

/// Allows websocket communication based a Transport base class
class WebSocketTransport implements Transport {
  StreamController<Map<String, dynamic>>? onEnvelopeStream =
      StreamController<Map<String, dynamic>>();

  @override
  WebSocket? socket;

  @override
  SessionCompression? compression;

  @override
  SessionEncryption? encryption;

  /// Allows saving the Session id
  String? sessionId;

  /// A [StreamController] to allow listening when the close method is executed
  @override
  StreamController<bool> onClose = StreamController<bool>();

  StreamController<bool>? onConnectionDoneStream = StreamController<bool>();

  final logger = LoggerService();

  @override
  Future<void> open(
    final String uri, {
    final bool useMtls = false,
  }) async {
    HttpClient? customClient;

    if (useMtls) {
      List<int> keyBytes = await _getKeyBytes();
      List<int> certificateChainBytes = await _getCertificateChainBytes();

      final context = SecurityContext(withTrustedRoots: true);
      context.usePrivateKeyBytes(keyBytes);
      context.useCertificateChainBytes(certificateChainBytes);

      customClient = HttpClient(context: context);
    }

    if (uri.contains('wss://')) {
      encryption = SessionEncryption.tls;
    } else {
      encryption = SessionEncryption.none;
    }

    compression = SessionCompression.none;

    try {
      // connect to the socket server
      socket = await WebSocket.connect(uri, customClient: customClient);
      logger.info('Connected to: $uri');

      // listen for responses from the server
      socket?.listen(
        // handle data from the server
        (data) {
          final response = jsonDecode(data);

          logger.info(
              'Envelope received: $uri \n' + prettyJson(response, indent: 2));

          onEnvelope?.add(response);
        },

        // handle errors
        onError: (error) {
          logger.shout('Error: $error');
          close();
        },

        // handle server ending connection
        onDone: () {
          logger.warning('Server closed the connection.');
          onConnectionDone?.add(true);
          close();
        },
      );

      socket?.pingInterval = const Duration(seconds: 5);
    } on WebSocketException catch (e) {
      if (e.message.endsWith('was not upgraded to websocket')) {
        throw InsecureSocketException(
            'This connection is not secure. Please contact the system administrator.');
      }
    } on HandshakeException {
      throw InsecureSocketException(
          'This connection is not secure. Please contact the system administrator.');
    }
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
  get onEnvelope => onEnvelopeStream;

  @override
  set onEnvelope(StreamController<Map<String, dynamic>>? _onEnvelope) {
    onEnvelopeStream = _onEnvelope;
  }

  @override
  get onConnectionDone => onConnectionDoneStream;

  @override
  set onConnectionDone(StreamController<bool>? _onConnectionDone) {
    onConnectionDoneStream = _onConnectionDone;
  }

  Future<List<int>> _getKeyBytes() async {
    return (await rootBundle
            .load('packages/${LimeUtils.packageName}/assets/keys/private.key'))
        .buffer
        .asInt8List();
  }

  Future<List<int>> _getCertificateChainBytes() async {
    return (await rootBundle.load(
            'packages/${LimeUtils.packageName}/assets/keys/certificate.cer'))
        .buffer
        .asInt8List();
  }
}
