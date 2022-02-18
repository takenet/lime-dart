import 'package:flutter/foundation.dart';
import 'package:lime/src/protocol/enums/command_method.enum.dart';

//import 'enums/command_method.enum.dart';
import 'enums/command_status.enum.dart';
import '../protocol/envelope.dart';
import '../protocol/envelope_id.dart';
import '../protocol/message.dart';
import '../protocol/node.dart';
import '../protocol/reason.dart';

class Command extends Envelope {
  static const String uriKey = 'uri';
  static const String typeKey = Message.typeKey;
  static const String resourceKey = 'resource';
  static const String methodKey = 'method';
  static const String statusKey = 'status';
  static const String reasonKey = 'reason';

  /// Initializes a new instance of the Command class.
  Command(
      {final String? id,
      final Node? from,
      final Node? to,
      final Node? pp,
      this.uri,
      this.method,
      this.reason,
      this.resource,
      this.status,
      this.type})
      : super(id: id ?? EnvelopeId.newId(), from: from, to: to, pp: pp);

  /// The universal identifier of the resource
  String? uri;

  /// MIME declaration of the resource type of the command.
  String? type;

  /// Server resource that are subject of the command
  dynamic resource;

  /// Action to be taken to the resource
  CommandMethod? method;

  /// Indicates the status of the action taken to the resource
  CommandStatus? status = CommandStatus.pending;

  /// Indicates a reason for the status
  Reason? reason;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> command = {};

    if (id != null) {
      command['id'] = id;
    }

    if (from != null) {
      command['from'] = from.toString();
    }

    if (to != null) {
      command['to'] = to.toString();
    }

    if (method != null) {
      command[methodKey] = describeEnum(method!);
    }

    if (status != null) {
      command[statusKey] = describeEnum(status!);
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

  factory Command.fromJson(Map<String, dynamic> json) {
    final envelope = Envelope.fromJson(json);

    final command = Command(
      id: envelope.id,
      from: envelope.from,
      to: envelope.to,
      pp: envelope.pp,
    );

    if (json.containsKey(reasonKey)) {
      command.reason = Reason.fromJson(json[reasonKey]);
    }

    if (json.containsKey(statusKey)) {
      command.status = CommandStatus.values
          .firstWhere((e) => describeEnum(e) == json[statusKey]);
    }

    if (json.containsKey(methodKey)) {
      command.method = CommandMethod.values
          .firstWhere((e) => describeEnum(e) == json[methodKey]);
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
