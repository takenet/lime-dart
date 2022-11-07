import 'enums/authentication_scheme.enum.dart';

/// Base class for the supported authentication schemes
abstract class Authentication {
  final AuthenticationScheme _scheme;
  AuthenticationScheme get scheme => _scheme;

  Authentication(this._scheme);
}
