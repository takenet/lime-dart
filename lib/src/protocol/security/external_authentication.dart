import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';
import '../extensions/string.extension.dart';

class ExternalAuthentication extends Authentication {
  static const String tokenKey = 'token';
  static const String issuerKey = 'issuer';

  /// Gets or sets the authentication token on base64 representation.
  String? token;

  /// Gets or sets the trusted token issuer.
  String? issuer;

  /// Initializes a new instance of the <see cref='ExternalAuthentication'/> class.
  ExternalAuthentication({this.token, this.issuer}) : super(AuthenticationScheme.external);

  /// Set a plain token to a base64 representation
  void setToBase64Token(final String? password) {
    token = password?.toBase64();
  }

  /// Gets the token decoded from the Base64 representation
  String getFromBase64Token() {
    return token?.fromBase64() ?? '';
  }
}
