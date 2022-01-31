import 'package:lime/protocol/enums/session_compression.enum.dart';
import 'package:lime/protocol/enums/session_encryption.enum.dart';
import 'package:lime/protocol/envelope.dart';

/// Defines a network connection with a node.
abstract class Transport {
  /// Sends an envelope to the remote node.
  void send(Envelope envelope);

  /// Register the specified listener for receiving envelopes.
  void setEnvelopeListener(TransportEnvelopeListener transportEnvelopeListener);

  /// Register the specified listener for receiving state change events.
  void setStateListener(TransportStateListener transportStateListener);

  /// Opens the transport connection with the specified Uri.
  void open(Uri uri);

  /// Checks if the client is connected.
  bool isConnected();

  /// Enumerates the supported compression options for the transport.
  List<SessionCompression> getSupportedCompression();

  /// Gets the current transport compression option.
  SessionCompression getCompression();

  /// Defines the compression mode for the transport.
  void setCompression(SessionCompression compression);

  ///Enumerates the supported encryption options for the transport.
  List<SessionEncryption> getSupportedEncryption();

  /// Gets the current transport encryption option.
  SessionEncryption getEncryption();

  /// Defines the encryption mode for the transport.

  void setEncryption(SessionEncryption encryption);
}

/// Defines a envelope transport listener.
abstract class TransportEnvelopeListener {
  //Occurs when a envelope is received by the transport.
  void onReceive(Envelope envelope);
}

///Defines a envelope transport state listener.
abstract class TransportStateListener {
  /// Occurs when the transport is about to be closed.
  void onClosing();

  /// Occurs after the transport was closed.
  void onClosed();

  /// Occurs when an exception is thrown during the receive process.

  void onException(Exception e);
}
