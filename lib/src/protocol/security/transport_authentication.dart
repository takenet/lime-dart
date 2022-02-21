import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';
import 'enums/domain_role.enum.dart';

class TransportAuthentication extends Authentication {
  /// The domain role determined by the <see cref="IAuthenticatableTransport.AuthenticateAsync"/> method call.
  /// This value should not be serialized.
  DomainRole? domainRole;

  TransportAuthentication({this.domainRole}) : super(AuthenticationScheme.transport);
}
