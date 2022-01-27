import 'package:lime/protocol/enums/authentication_scheme.enum.dart';

/// Base class for the supported
/// authentication schemes
abstract class Authentication {
  AuthenticationScheme scheme;

  Authentication({required this.scheme});

  AuthenticationScheme getAuthenticationScheme() => scheme;
}
