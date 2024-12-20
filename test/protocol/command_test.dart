import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lime/lime.dart';

void main() {
  const String jsonPath = "test_resources/command.json";
  Map<String, dynamic> json = <String, dynamic>{};

  setUp(() async {
    final file = File(jsonPath);
    json = jsonDecode(await file.readAsString());
  });

  group('Command.fromJson', () {
    test('should returns a Command object from a json document', () async {
      final command = Command.fromJson(json);

      expect(command, isA<Command>());
    });
    test('should set the Command properties ', () async {
      final command = Command.fromJson(json);

      expect(command.metadata, equals(json['metadata']));
      expect(command.method.name, equals(json['method']));
      expect(command.resource, equals(json['resource']));
      expect(command.status!.name, equals(json['status']));
      expect(command.type, equals(json['type']));
      expect(command.uri, equals(json['uri']));
      expect(
          command.reason!.description, equals(json['reason']['description']));
      expect(command.reason!.code, equals(json['reason']['code']));
    });
  });

  group('Command.toJson', () {
    test('should returns a Json object from a Command object', () async {
      final command = Command.fromJson(json);
      final jsonDoc = command.toJson();

      expect(jsonDoc, isA<Map>());
    });
    test('should set the json properties ', () async {
      final command = Command.fromJson(json);
      final jsonDoc = command.toJson();

      expect(jsonDoc['metadata'], equals(command.metadata));
      expect(jsonDoc['method'], equals(command.method.name));
      expect(jsonDoc['resource'], equals(command.resource));
      expect(jsonDoc['status'], equals(command.status!.name));
      expect(jsonDoc['type'], equals(command.type));
      expect(jsonDoc['uri'], equals(command.uri));
      expect(jsonDoc['reason']['description'],
          equals(command.reason!.description));
      expect(jsonDoc['reason']['code'], equals(command.reason!.code));
    });
  });
}
