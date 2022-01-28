import 'package:lime/protocol/enums/session_compression.enum.dart';
import 'package:lime/protocol/enums/session_encryption.enum.dart';
import 'package:lime/protocol/envelope.dart';
import 'package:lime/protocol/reason.dart';
import 'package:lime/security/authentication.dart';
import 'package:lime/security/enums/authentication_scheme.enum.dart';

import 'enums/session_state.enum.dart';

/// Allows the configuration and establishment of the communication channel between nodes.
class Session extends Envelope {
  static const String stateKey = 'state';
  static const String modeKey = 'mode';
  static const String encryptionOptionsKey = 'encryptionOptions';
  static const String encryptionKey = 'encryption';
  static const String compressionOptionsKey = 'compressionOptions';
  static const String compressionKey = 'compression';
  static const String schemeOptionsKey = 'schemeOptions';
  static const String schemeKey = 'scheme';
  static const String authenticationKey = 'authentication';
  static const String reasonKey = 'reason';

  /// Initializes a new instance of the Session class.
  Session() : super();

  /// Informs or changes the state of a session.
  /// Only the server can change the session state, but the client can request the state transition.
  SessionState? state;

  /// Encryption options provided by the server during the session negotiation.
  List<SessionEncryption>? encryptionOptions;

  /// The encryption option selected for the session.
  /// This property is provided by the client in the
  /// negotiation and by the server in the confirmation
  /// after that.
  SessionEncryption? encryption;

  /// Compression options provided by the
  /// server during the session negotiation.
  List<SessionCompression>? compressionOptions;

  /// The compression option selected for the session.
  /// This property is provided by the client in the
  /// negotiation and by the server in the confirmation
  /// after that.
  SessionCompression? compression;

  /// List of available authentication schemas
  /// for session authentication provided by the server.
  List<AuthenticationScheme>? schemeOptions;

  /// The authentication scheme option selected
  /// for the session. This property must be present
  /// if the property authentication is defined.
  AuthenticationScheme? scheme;

  /// Authentication data, related to the selected schema.
  /// Information like password sent by the client or
  /// roundtrip data sent by the server.
  Authentication? authentication;

  /// In cases where the client receives a session with
  /// failed state, this property should provide more
  /// details about the problem.
  Reason? reason;
}
