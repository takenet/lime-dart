import 'authentication.dart';
import 'enums/authentication_scheme.enum.dart';

class GuestAuthentication extends Authentication {
  GuestAuthentication() : super(AuthenticationScheme.guest);
}
