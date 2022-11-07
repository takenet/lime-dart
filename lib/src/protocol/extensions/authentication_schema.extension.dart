import 'package:flutter/foundation.dart';
import 'package:lime/lime.dart';

extension AuthenticationSchemaExtension on AuthenticationScheme {
  AuthenticationScheme getValue(String? value) =>
      AuthenticationScheme.values.firstWhere((e) => describeEnum(e) == value,
          orElse: () => AuthenticationScheme.unknown);
}
