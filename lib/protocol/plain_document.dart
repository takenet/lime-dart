import 'package:lime/protocol/document.dart';
import 'package:lime/protocol/media_type.dart';

class PlainDocument extends Document {
  /// Initializes a new instance of the PlainDocument class.
  PlainDocument.fromMedia(MediaType mediaType) : super(mediaType: mediaType);

  /// Initializes a new instance of the PlainDocument class.
  PlainDocument(String val, MediaType mediaType) : super(mediaType: mediaType) {
    if (mediaType.suffix?.isNotEmpty ?? false) {
      throw ArgumentError.value("Invalid media type. The suffix value should be empty.", 'mediaType');
    }

    value = val;
  }

  /// The value of the document.
  String? value;

  /// Returns a String that represents this instance.
  @override
  String toString() => value ?? '';

  /// Performs an implicit conversion from PlainDocument to String.
  String? fromDocument(PlainDocument plainDocument) => plainDocument.value;
}
