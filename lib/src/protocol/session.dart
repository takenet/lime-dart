import 'enums/session_compression.enum.dart';
import 'enums/session_encryption.enum.dart';
import 'enums/session_state.enum.dart';
import 'envelope.dart';
import 'guid.dart';
import 'reason.dart';
import 'security/authentication.dart';
import 'security/enums/authentication_scheme.enum.dart';
import 'security/external_authentication.dart';
import 'security/key_authentication.dart';
import 'security/plain_authentication.dart';

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
  Session(
      {final String? id,
      super.from,
      super.to,
      super.pp,
      Map<String, String>? super.metadata,
      this.state,
      this.scheme,
      this.authentication})
      : super(
          id: id ?? guid(),
        );

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

  /// Allows converting a [Session] object to a [Map] collection of key/value pairs
  Map<String, dynamic> toJson() {
    Map<String, dynamic> session = {};

    if (state != null) {
      session[stateKey] =
          state!.name == 'isNew' ? 'new' : state!.name;
    }

    session[Envelope.idKey] = id;

    if (from != null) {
      session[Envelope.fromKey] = from.toString();
    }

    if (to != null) {
      session[Envelope.toKey] = to.toString();
    }

    if (pp != null) {
      session[Envelope.ppKey] = pp.toString();
    }

    if (metadata != null) {
      session[Envelope.metadataKey] = metadata;
    }

    if (scheme != null) {
      session[schemeKey] = scheme!.name;
    }

    if (authentication != null) {
      if (authentication is KeyAuthentication) {
        final keyAuth = authentication as KeyAuthentication;
        session[authenticationKey] = {"key": keyAuth.key};
      } else if (authentication is ExternalAuthentication) {
        final externalAuth = authentication as ExternalAuthentication;
        session[authenticationKey] = {
          "token": externalAuth.token,
          "issuer": externalAuth.issuer,
          "scheme": externalAuth.scheme.name
        };
      } else if (authentication is PlainAuthentication) {
        final plainAuth = authentication as PlainAuthentication;
        session[authenticationKey] = {'password': plainAuth.password};
      }
    }

    return session;
  }

  /// Allows converting a collection of key/value pairs, [Map] to a [Session] object
  factory Session.fromJson(Map<String, dynamic> json) {
    final envelope = Envelope.fromJson(json);

    final session = Session(
      id: envelope.id,
      from: envelope.from,
      to: envelope.to,
      pp: envelope.pp,
    );

    if (json.containsKey(stateKey)) {
      session.state = SessionState.values.firstWhere((e) => e.name == json[stateKey]);
    }

    if (json.containsKey(schemeOptionsKey)) {
      final schemeOptionsList = json[schemeOptionsKey] as List;
      final schemeOptions = schemeOptionsList
          .map((e) => AuthenticationScheme.values
              .firstWhere((e2) => e2.name == e))
          .toList();
      session.schemeOptions = schemeOptions;
    }

    if (json.containsKey(reasonKey)) {
      session.reason = Reason.fromJson(json[reasonKey]);
    }

    return session;
  }
}
