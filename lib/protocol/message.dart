import 'package:lime/protocol/document.dart';
import 'package:lime/protocol/envelope.dart';
import 'package:lime/protocol/interfaces/idocument.dart';
import 'package:lime/protocol/media_type.dart';

class Message extends Envelope implements IDocumentContainer {
  static const String typeKey = 'type';
  static const String contentKey = 'content';

  /// Initializes a new instance of the Message class.
  Message({final String? id}) : super(id: id);

  ///  MIME declaration of the content type of the message.
  MediaType? get type => content?.getMediaType();

  /// Message body content
  Document? content;

  /// Gets the contained document.
  @override
  Document? getDocument() => content;
}
