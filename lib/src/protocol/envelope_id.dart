import 'package:uuid/uuid.dart';

/// Utility class for generating envelope ids.
class EnvelopeId {
  static const uuid = Uuid();

  /// Generates a new envelope identifier.
  static String newId() => uuid.v4();
}
