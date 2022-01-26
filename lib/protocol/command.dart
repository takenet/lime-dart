import 'package:lime/protocol/document.dart';
import 'package:lime/protocol/enums/command_method.enum.dart';
import 'package:lime/protocol/enums/command_status.enum.dart';
import 'package:lime/protocol/envelope.dart';
import 'package:lime/protocol/envelope_id.dart';
import 'package:lime/protocol/interfaces/idocument.dart';
import 'package:lime/protocol/lime_uri.dart';
import 'package:lime/protocol/media_type.dart';
import 'package:lime/protocol/message.dart';
import 'package:lime/protocol/reason.dart';

class Command extends Envelope implements IDocumentContainer {
  static const String uriKey = 'uri';
  static const String typeKey = Message.typeKey;
  static const String resourceKey = 'resource';
  static const String methodKey = 'method';
  static const String statusKey = 'status';
  static const String reasonKey = 'reason';

  /// Initializes a new instance of the Command class.
  Command({String? id}) : super(id: id ?? EnvelopeId.newId());

  /// The universal identifier of the resource
  LimeUri? uri;

  /// MIME declaration of the resource type of the command.
  MediaType? get type => resource?.getMediaType();

  /// Server resource that are subject of the command
  Document? resource;

  /// Action to be taken to the resource
  CommandMethod? method;

  /// Indicates the status of the action taken to the resource
  CommandStatus? status = CommandStatus.pending;

  /// Indicates a reason for the status
  Reason? reason;

  /// Gets the contained document.
  @override
  Document? getDocument() => resource;
}
