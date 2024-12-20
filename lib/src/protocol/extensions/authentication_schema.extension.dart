import 'package:lime/lime.dart';

extension AuthenticationSchemaExtension on AuthenticationScheme {
  AuthenticationScheme getValue(String? value) =>
      AuthenticationScheme.values.firstWhere((e) => e.name == value,
          orElse: () => AuthenticationScheme.unknown);
}
