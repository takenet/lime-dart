import '../extensions/string.extension.dart';
import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';

/// Defines a authentication scheme that uses a key for authentication.
/// Should be used only with encrypted sessions.
class KeyAuthentication extends Authentication {
  static const String keyKey = 'key';

  /// Base64 representation of the identity key.
  String? key;

  /// Initializes a new instance of the [KeyAuthentication] class.
  KeyAuthentication({this.key}) : super(AuthenticationScheme.key);

  /// Set a plain key to a Base64 representation.
  void setToBase64Key(final String? key) {
    this.key = key?.toBase64();
  }

  /// Gets the plain key decoded from the Base64 representation.
  String getFromBase64Key() {
    return key?.fromBase64() ?? '';
  }
}
