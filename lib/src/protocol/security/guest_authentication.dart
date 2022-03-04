import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';

/// Defines a guest authentication scheme
class GuestAuthentication extends Authentication {
  /// Initializes a new instance of the [GuestAuthentication] class.
  GuestAuthentication() : super(AuthenticationScheme.guest);
}
