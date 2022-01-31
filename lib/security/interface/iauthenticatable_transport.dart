import 'package:lime/network/interfaces/itransport.dart';
import 'package:lime/protocol/identity.dart';
import 'package:lime/security/enums/domain_role.enum.dart';

/// Defines a transport that supports authentication.
abstract class IAuthenticatableTransport extends ITransport {
  /// Authenticate the identity in the transport layer.
  Future<DomainRole> authenticate(Identity identity);
}
