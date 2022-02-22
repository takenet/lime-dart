import 'package:flutter/foundation.dart';
import 'envelope.dart';
import 'guid.dart';
import 'node.dart';
import 'reason.dart';
import 'security/enums/authentication_scheme.enum.dart';
import 'security/external_authentication.dart';
import 'security/key_authentication.dart';
import 'security/authentication.dart';
import 'enums/session_compression.enum.dart';
import 'enums/session_encryption.enum.dart';
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
  Session(
      {final String? id,
      final Node? from,
      final Node? to,
      final Node? pp,
      final Map<String, String>? metadata,
      this.state,
      this.scheme,
      this.authentication})
      : super(
          id: id ?? guid(),
          from: from,
          to: to,
          pp: pp,
          metadata: metadata,
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> session = {};

    if (state != null) {
      session[stateKey] = describeEnum(state!) == 'isNew' ? 'new' : describeEnum(state!);
    }

    session['id'] = id;

    if (from != null) {
      session['from'] = from.toString();
    }

    if (to != null) {
      session['to'] = to.toString();
    }

    if (scheme != null) {
      session[schemeKey] = describeEnum(scheme!);
    }

    if (authentication != null) {
      if (authentication is KeyAuthentication) {
        KeyAuthentication keyAuth = authentication as KeyAuthentication;
        session[authenticationKey] = {"key": keyAuth.key};
      }
      if (authentication is ExternalAuthentication) {
        ExternalAuthentication externalAuth = authentication as ExternalAuthentication;
        session[authenticationKey] = {
          "token": externalAuth.token,
          "issuer": externalAuth.issuer,
          "scheme": describeEnum(externalAuth.scheme)
        };
      }
    }

    return session;
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    final envelope = Envelope.fromJson(json);

    final session = Session(
      id: envelope.id,
      from: envelope.from,
      to: envelope.to,
      pp: envelope.pp,
    );

    if (json.containsKey(stateKey)) {
      session.state = SessionState.values.firstWhere((e) => describeEnum(e) == json[stateKey]);
    }

    if (json.containsKey(schemeOptionsKey)) {
      final schemeOptionsList = json[schemeOptionsKey] as List;
      final schemeOptions =
          schemeOptionsList.map((e) => AuthenticationScheme.values.firstWhere((e2) => describeEnum(e2) == e)).toList();
      session.schemeOptions = schemeOptions;
    }

    if (json.containsKey(reasonKey)) {
      session.reason = Reason.fromJson(json[reasonKey]);
    }

    return session;
  }
}
