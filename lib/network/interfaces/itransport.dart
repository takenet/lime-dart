import 'dart:async';

import 'package:lime/network/interfaces/itransport_information.dart';
import 'package:lime/protocol/enums/session_compression.enum.dart';
import 'package:lime/protocol/enums/session_encryption.enum.dart';
import 'package:lime/protocol/envelope.dart';

/// Defines a network connection with a node.
abstract class ITransport extends ITransportInformation {
  /// Sends an envelope to the remote node.
  Future<void> send(Envelope envelope);

  /// Receives an envelope from the remote node.
  Future<Envelope> receive();

  /// Opens the transport connection with the specified Uri.
  Future<void> open(Uri uri);

  /// Closes the connection
  Future<void> close();

  /// Enumerates the supported compression options for the transport.
  List<SessionCompression> getSupportedCompression();

  /// Defines the compression mode for the transport.
  Future<void> setCompression(SessionCompression compression);

  /// Enumerates the supported encryption options for the transport.
  List<SessionEncryption> getSupportedEncryption();

  /// Defines the encryption mode for the transport.
  Future<void> setEncryption(SessionEncryption encryption);

  /// Sets a transport option value.
  Future<void> setOption(String name, value);
}
