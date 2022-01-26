import 'package:flutter/material.dart';
import 'package:lime/protocol/media_type.dart';
import 'package:lime/protocol/plain_document.dart';

/// Defines a entity with a MediaType.
abstract class Document {
  @protected
  MediaType mediaType;

  /// Initializes a new instance of the class.
  @protected
  Document({required this.mediaType});

  /// Gets the type of the media for the document.
  MediaType getMediaType() => mediaType;

  Document? fromString(String? value) {
    if (value == null) return null;

    return PlainDocument(value, MediaType.textPlain);
  }
}
