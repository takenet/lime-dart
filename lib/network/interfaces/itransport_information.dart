import 'package:lime/protocol/enums/session_compression.enum.dart';
import 'package:lime/protocol/enums/session_encryption.enum.dart';

/// Provides information about a transport connection.
abstract class ITransportInformation {
  /// Gets the current transport compression option.
  SessionCompression? compression;

  /// Gets the current transport encryption option.
  SessionEncryption? encryption;

  /// Indicates if the transport is connected.
  bool? isConnected;

  /// Gets the local endpoint address.
  String? localEndPoint;

  /// Gets the remote endpoint address.
  String? remoteEndPoint;

  /// Gets specific transport options informations.
  Map<String, String>? options;
}
