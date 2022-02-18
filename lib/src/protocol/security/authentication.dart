import 'enums/authentication_scheme.enum.dart';

abstract class Authentication {
  final AuthenticationScheme _scheme;
  AuthenticationScheme get scheme => _scheme;

  Authentication(final this._scheme);
}
