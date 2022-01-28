import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';

void main() {
  group('toIdentity()', () {
    test('should returns identity of the node', () {
      final identity = Identity(name: 'name', domain: 'domain');
      final node = Node(name: 'name', domain: 'domain', instance: 'instance');

      expect(node.toIdentity(), equals(identity));
    });
  });

  group('toString()', () {
    test('should returns identity without instance if instance is null', () {
      final node = Node(name: 'name', domain: 'domain');

      expect(node.toString(), equals('name@domain'));
    });
    test('should returns identity with instance if instance is not null', () {
      final node = Node(name: 'name', domain: 'domain', instance: 'instance');

      expect(node.toString(), equals('name@domain/instance'));
    });
  });

  group('Node.parse()', () {
    test('should returns node without instance if instance is null', () {
      final node = Node(name: 'name', domain: 'domain');

      expect(Node.parse('name@domain'), equals(node));
    });
    test('should returns node with instance if instance is not null', () {
      final node = Node(name: 'name', domain: 'domain', instance: 'instance');

      expect(Node.parse('name@domain/instance'), equals(node));
    });
  });

  group('Equals', () {
    test('should returns true with equals properties', () {
      final node = Node(name: 'name', domain: 'domain', instance: 'instance');
      final node2 =
          Node(name: node.name, domain: node.domain, instance: node.instance);

      expect(node, equals(node2));
      expect(node.hashCode, equals(node2.hashCode));
    });
    test('should returns false with different properties', () {
      final node = Node(name: 'name', domain: 'domain', instance: 'instance');
      final node2 =
          Node(name: 'name2', domain: 'domain2', instance: 'instance2');

      expect(node, isNot(equals(node2)));
      expect(node.hashCode, isNot(equals(node2.hashCode)));
    });
  });
}
