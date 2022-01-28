import 'package:lime/security/authentication.dart';
import 'package:lime/extensions/string.extension.dart';
import 'package:lime/security/enums/authentication_scheme.enum.dart';

class ExternalAuthentication extends Authentication {
  static const String tokenKey = 'token';
  static const String issuerKey = 'issuer';

  /// Initializes a new instance of the <see cref='ExternalAuthentication'/> class.
  ExternalAuthentication() : super(AuthenticationScheme.external);

  /// Gets or sets the authentication token on base64 representation.
  String? token;

  /// Gets or sets the trusted token issuer.
  String? issuer;

  /// Set a plain token to a base64 representation
  void setToBase64Token(String password) {
    token = password.isEmpty ? password : password.toBase64();
  }

  /// Gets the token decoded from the Base64 representation
  String getFromBase64Token() {
    return (token?.isEmpty ?? true ? token : token?.fromBase64()) ?? '';
  }
}
