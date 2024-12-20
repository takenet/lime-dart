import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lime/lime.dart';

void main() async {
  const String jsonPath = "test_resources/session.json";
  Map<String, dynamic> json = <String, dynamic>{};

  final file = File(jsonPath);
  json = jsonDecode(await file.readAsString());

  group('Session.fromJson', () {
    test('should returns a Session object from a json document', () async {
      final session = Session.fromJson(json);

      expect(session, isA<Session>());
    });
    test('should set the Session properties ', () async {
      final session = Session.fromJson(json);

      expect(session.state!.name, equals(json['state']));
      expect(
          session.reason!.description, equals(json['reason']['description']));
      expect(session.reason!.code, equals(json['reason']['code']));
      expect((session.schemeOptions!.length),
          equals(json['schemeOptions'].length));
    });
  });

  group('Session.toJson', () {
    test('should returns a Json object from a Session object', () async {
      final session = Session.fromJson(json);
      final jsonDoc = session.toJson();

      expect(jsonDoc, isA<Map>());
    });
  });
}
