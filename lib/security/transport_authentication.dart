import 'package:lime/security/authentication.dart';
import 'package:lime/security/enums/authentication_scheme.enum.dart';
import 'package:lime/security/enums/domain_role.enum.dart';

class TransportAuthentication extends Authentication {
  TransportAuthentication() : super(AuthenticationScheme.transport);

  /// The domain role determined by the <see cref="IAuthenticatableTransport.AuthenticateAsync"/> method call.
  /// This value should not be serialized.
  DomainRole? domainRole;
}
