import 'enums/command_method.enum.dart';
import 'enums/command_status.enum.dart';
import 'envelope.dart';
import 'guid.dart';
import 'message.dart';
import 'reason.dart';

/// Allows the manipulation of node resources, like server session parameters or information related to the network nodes.
class Command extends Envelope {
  static const String uriKey = 'uri';
  static const String typeKey = Message.typeKey;
  static const String resourceKey = 'resource';
  static const String methodKey = 'method';
  static const String statusKey = 'status';
  static const String reasonKey = 'reason';

  /// The universal identifier of the resource
  String? uri;

  /// MIME declaration of the resource type of the command.
  String? type;

  /// Server resource that are subject of the command
  dynamic resource;

  /// Action to be taken to the resource
  CommandMethod method;

  /// Indicates the status of the action taken to the resource
  CommandStatus? status = CommandStatus.pending;

  /// Indicates a reason for the status
  Reason? reason;

  /// Initializes a new instance of the Command class.
  Command({
    final String? id,
    super.from,
    super.to,
    super.pp,
    super.metadata,
    this.uri,
    required this.method,
    this.reason,
    this.resource,
    this.status,
    this.type,
  }) : super(id: id ?? guid());

  /// Allows converting a [Command] object to a [Map] collection of key/value pairs
  Map<String, dynamic> toJson() {
    Map<String, dynamic> command = {};

    command[Envelope.idKey] = id;
    command[methodKey] = method.name;

    if (from != null) {
      command[Envelope.fromKey] = from.toString();
    }

    if (to != null) {
      command[Envelope.toKey] = to.toString();
    }

    if (pp != null) {
      command[Envelope.ppKey] = pp.toString();
    }

    if (metadata != null) {
      command[Envelope.metadataKey] = metadata;
    }

    if (status != null) {
      command[statusKey] = status!.name;
    }

    if (uri != null) {
      command[uriKey] = uri;
    }

    if (reason != null) {
      command[reasonKey] = reason?.toJson();
    }

    if (type != null) {
      command[typeKey] = type;
    }

    if (resource != null) {
      command[resourceKey] = resource;
    }

    return command;
  }

  /// Allows converting a collection of key/value pairs, [Map] to a [Command] object
  factory Command.fromJson(Map<String, dynamic> json) {
    final envelope = Envelope.fromJson(json);

    final command = Command(
      id: envelope.id,
      from: envelope.from,
      to: envelope.to,
      pp: envelope.pp,
      metadata: envelope.metadata,
      method: json[methodKey] != null
          ? CommandMethod.values.firstWhere((e) => e.name == json[methodKey])
          : CommandMethod.unknown,
    );

    if (json.containsKey(reasonKey)) {
      command.reason = Reason.fromJson(json[reasonKey]);
    }

    if (json.containsKey(statusKey)) {
      command.status =
          CommandStatus.values.firstWhere((e) => e.name == json[statusKey]);
    }

    if (json.containsKey(uriKey)) {
      command.uri = json[uriKey];
    }

    if (json.containsKey(typeKey)) {
      command.type = json[typeKey];
    }

    if (json.containsKey(resourceKey)) {
      command.resource = json[resourceKey];
    }

    return command;
  }
}
