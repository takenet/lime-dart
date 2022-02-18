import '../document.dart';

/// Defines a type that contains a Document instance.
abstract class IDocumentContainer {
  /// Gets the contained document.
  Document? getDocument();
}
