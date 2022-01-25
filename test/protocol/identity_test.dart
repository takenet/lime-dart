import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';

void main() {
  group('toString()', () {
    test('should returns name@domain', () {
      final identity1 = Identity('name', 'domain');

      expect(identity1.toString(), equals('name@domain'));
    });
  });

  group('Identity.parse()', () {
    test('should returns identity if is a node', () {
      final identity = Identity('name', 'domain');
      final node = Node(identity: identity);

      expect(Identity.parse(node), equals(node.identity));
    });
    test('should returns identity if is a identity', () {
      final identity = Identity('name', 'domain');

      expect(Identity.parse(identity), equals(identity));
    });
    test('should returns identity if is a string', () {
      expect(
        Identity.parse('name@domain'),
        equals(Identity('name', 'domain')),
      );
    });
  });

  group('Equals', () {
    test('should returns true with equals properties', () {
      final identity1 = Identity('name', 'domain');
      final identity2 = Identity(identity1.name, identity1.domain);

      expect(identity1, equals(identity2));
      expect(identity1.hashCode, equals(identity2.hashCode));
    });
    test('should returns true with equals properties and different case', () {
      final identity1 = Identity('name', 'domain');
      final identity2 = Identity(
          identity1.name.toUpperCase(), identity1.domain.toUpperCase());

      expect(identity1, equals(identity2));
      expect(identity1.hashCode, equals(identity2.hashCode));
    });
    test('should returns false with different properties', () {
      final identity1 = Identity('name', 'domain');
      final identity2 = Identity('name2', 'domain2');

      expect(identity1, isNot(equals(identity2)));
      expect(identity1.hashCode, isNot(equals(identity2.hashCode)));
    });
  });
}
