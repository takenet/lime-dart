import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';
import 'enums/domain_role.enum.dart';

/// Defines a transport layer authentication scheme.
class TransportAuthentication extends Authentication {
  DomainRole? domainRole;

  TransportAuthentication({this.domainRole})
      : super(AuthenticationScheme.transport);
}
