import 'package:lime/security/authentication.dart';
import 'package:lime/security/enums/authentication_scheme.enum.dart';

class GuestAuthentication extends Authentication {
  GuestAuthentication() : super(AuthenticationScheme.guest);
}
