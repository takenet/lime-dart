import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';
import 'dart:convert';
import 'dart:io';

void main() async {
  const String jsonPath = "test_resources/notification.json";
  Map<String, dynamic> json = <String, dynamic>{};

  final file = File(jsonPath);
  json = jsonDecode(await file.readAsString());

  group('Notification.fromJson', () {
    test('should returns a Notification object from a json document', () async {
      final notification = Notification.fromJson(json);

      expect(notification, isA<Notification>());
    });
    test('should set the Notification properties ', () async {
      final notification = Notification.fromJson(json);

      expect(describeEnum(notification.event!), equals(json['event']));
      expect(notification.reason!.description,
          equals(json['reason']['description']));
      expect(notification.reason!.code, equals(json['reason']['code']));
    });
  });

  group('Notification.toJson', () {
    test('should returns a Json object from a Notification object', () async {
      final notification = Notification.fromJson(json);
      final jsonDoc = notification.toJson();

      expect(jsonDoc, isA<Map>());
    });
    test('should set the json properties ', () async {
      final notification = Notification.fromJson(json);
      final jsonDoc = notification.toJson();

      expect(jsonDoc['event'], equals(describeEnum(notification.event!)));
      expect(jsonDoc['reason']['description'],
          equals(notification.reason!.description));
      expect(jsonDoc['reason']['code'], equals(notification.reason!.code));
    });
  });
}
