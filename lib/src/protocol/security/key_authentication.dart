import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';
import '../extensions/string.extension.dart';

class KeyAuthentication extends Authentication {
  static const String keyKey = 'key';

  /// Base64 representation of the identity key.
  String? key;

  KeyAuthentication({this.key}) : super(AuthenticationScheme.key);

  /// Set a plain key to a Base64 representation.
  void setToBase64Key(final String? _key) {
    key = _key?.toBase64();
  }

  /// Gets the plain key decoded from the Base64 representation.
  String getFromBase64Key() {
    return key?.fromBase64() ?? '';
  }
}
