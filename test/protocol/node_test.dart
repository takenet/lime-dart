import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';

void main() {
  group('toIdentity()', () {
    test('should returns identity of the node', () {
      final identity = Identity('name', 'domain');
      final node = Node(identity: identity);

      expect(node.toIdentity(), equals(identity));
    });
  });

  group('toString()', () {
    test('should returns identity without instance if instance is null', () {
      final identity = Identity('name', 'domain');
      final node = Node(identity: identity);

      expect(node.toString(), equals('name@domain'));
    });
    test('should returns identity with instance if instance is not null', () {
      final identity = Identity('name', 'domain');
      final node = Node(identity: identity, instance: 'instance');

      expect(node.toString(), equals('name@domain/instance'));
    });
  });

  group('Node.parse()', () {
    test('should returns node if is a node', () {
      final identity = Identity('name', 'domain');
      final possibleNode = Node(identity: identity);

      expect(Node.parse(possibleNode), equals(possibleNode));
    });
    test('should returns node if is not a node', () {
      final identity = Identity('name', 'domain');
      final possibleNode = Node(identity: identity, instance: 'instance');

      expect(Node.parse('name@domain/instance'), equals(possibleNode));
    });
  });

  group('Equals', () {
    test('should returns true with equals properties', () {
      final identity = Identity('name', 'domain');
      final node = Node(identity: identity, instance: 'instance');
      final node2 = Node(identity: node.identity, instance: node.instance);

      expect(node, equals(node2));
      expect(node.hashCode, equals(node2.hashCode));
    });
    test('should returns false with different properties', () {
      final identity = Identity('name', 'domain');
      final node = Node(identity: identity, instance: 'instance');
      final node2 = Node(identity: node.identity, instance: 'instance2');

      expect(node, isNot(equals(node2)));
      expect(node.hashCode, isNot(equals(node2.hashCode)));
    });
  });
}
