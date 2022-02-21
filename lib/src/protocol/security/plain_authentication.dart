import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';
import '../extensions/string.extension.dart';

class PlainAuthentication extends Authentication {
  static const String passwordKey = 'password';

  /// Base64 representation of the identity password
  String? password;

  PlainAuthentication({this.password}) : super(AuthenticationScheme.plain);

  /// Set a plain password to a Base64 representation
  void setToBase64Password(final String? _password) {
    password = _password?.toBase64();
  }

  /// Gets the plain password decoded from the Base64 representation
  String getFromBase64Password() {
    return password?.fromBase64() ?? '';
  }
}
