import '../extensions/string.extension.dart';
import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';

/// Defines a plain authentication scheme, that uses a password for authentication.
/// Should be used only with encrypted sessions.
class PlainAuthentication extends Authentication {
  static const String passwordKey = 'password';

  /// Base64 representation of the identity password
  String? password;

  /// Initializes a new instance of the [PlainAuthentication] class.
  PlainAuthentication({this.password}) : super(AuthenticationScheme.plain);

  /// Set a plain password to a Base64 representation
  void setToBase64Password(final String? password) {
    this.password = password?.toBase64();
  }

  /// Gets the plain password decoded from the Base64 representation
  String getFromBase64Password() {
    return password?.fromBase64() ?? '';
  }
}
