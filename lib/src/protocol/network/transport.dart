import 'dart:async';

import '../enums/session_compression.enum.dart';
import '../enums/session_encryption.enum.dart';
import '../envelope.dart';

import 'envelope_listener.dart';

/// Base class for the supported transport types
abstract class Transport extends EnvelopeListener {
  /// Opens the transport connection with the specified Uri.
  Future<void> open(
    final String uri, {
    final bool useMtls = false,
  });

  /// Closes the connection
  Future<void> close();

  /// Allows sends an envelope to the connected node.
  void send(Envelope envelope);

  /// Enumerates the supported compression options for the transport.
  SessionCompression? compression;

  /// Enumerates the supported encryption options for the transport.
  SessionEncryption? encryption;

  /// A [StreamController] to allow listening when the [close] method is executed
  StreamController<bool> onClose = StreamController<bool>();
}
