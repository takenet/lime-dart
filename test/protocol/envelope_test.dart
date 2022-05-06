import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  const String jsonPath = "test_resources/envelope.json";
  Map<String, dynamic> json = <String, dynamic>{};

  final file = File(jsonPath);
  json = jsonDecode(await file.readAsString());

  group('Envelope.fromJson', () {
    test('should returns a Envelope object from a json document', () async {
      final envelope = Envelope.fromJson(json);

      expect(envelope, isA<Envelope>());
    });
    test('should set the Envelope properties ', () async {
      final envelope = Envelope.fromJson(json);

      expect(envelope.id, equals(json['id']));
      expect(envelope.to.toString(), equals(json['to']));
      expect(envelope.from.toString(), equals(json['from']));
      expect(envelope.pp.toString(), equals(json['pp']));
      expect(envelope.metadata, equals(json['metadata']));
    });
  });
}
