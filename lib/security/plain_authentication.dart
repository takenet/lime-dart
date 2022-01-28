import 'package:lime/security/authentication.dart';
import 'package:lime/security/enums/authentication_scheme.enum.dart';
import 'package:lime/extensions/string.extension.dart';

class PlainAuthentication extends Authentication {
  static const String passwordKey = 'password';

  PlainAuthentication() : super(AuthenticationScheme.plain);

  /// Base64 representation of the identity password
  String? password;

  /// Set a plain password to a Base64 representation
  void setToBase64Password(final String? _password) {
    password = _password?.toBase64();
  }

  /// Gets the plain password decoded from the Base64 representation
  String getFromBase64Password() {
    return password?.fromBase64() ?? '';
  }
}
