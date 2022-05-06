import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  const String jsonPath = "test_resources/reason.json";
  Map<String, dynamic> json = <String, dynamic>{};

  final file = File(jsonPath);
  json = jsonDecode(await file.readAsString());

  group('Reason.fromJson', () {
    test('should returns a Reason object from a json document', () async {
      final reason = Reason.fromJson(json);

      expect(reason, isA<Reason>());
    });
    test('should set the Reason properties ', () async {
      final reason = Reason.fromJson(json);

      expect(reason.code, equals(json['code']));
      expect(reason.description, equals(json['description']));
    });
  });

  group('Reason.toJson', () {
    test('should returns a Json object from a Reason object', () async {
      final reason = Reason.fromJson(json);
      final jsonDoc = reason.toJson();

      expect(jsonDoc, isA<Map>());
    });
    test('should set the json properties ', () async {
      final reason = Reason.fromJson(json);
      final jsonDoc = reason.toJson();

      expect(jsonDoc['code'], equals(reason.code));
      expect(jsonDoc['description'], equals(reason.description));
    });
  });

  group('toString()', () {
    test("should returns 'description (Code code)'", () {
      final reason = Reason(code: 0, description: 'timeout');

      expect(reason.toString(), equals('timeout (Code 0)'));
    });
  });
}
