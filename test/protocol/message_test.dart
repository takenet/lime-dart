import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  const String jsonPath = "test_resources/message.json";
  Map<String, dynamic> json = <String, dynamic>{};

  final file = File(jsonPath);
  json = jsonDecode(await file.readAsString());

  group('Message.fromJson', () {
    test('should returns a Message object from a json document', () async {
      final message = Message.fromJson(json);

      expect(message, isA<Message>());
    });
    test('should set the Message properties ', () async {
      final message = Message.fromJson(json);

      expect(message.type, equals(json['type']));
      expect(message.content, equals(json['content']));
    });
  });

  group('Message.toJson', () {
    test('should returns a Json object from a Message object', () async {
      final message = Message.fromJson(json);
      final jsonDoc = message.toJson();

      expect(jsonDoc, isA<Map>());
    });
    test('should set the json properties ', () async {
      final message = Message.fromJson(json);
      final jsonDoc = message.toJson();

      expect(jsonDoc['type'], equals(message.type));
      expect(jsonDoc['content'], equals(message.content));
    });
  });
}
