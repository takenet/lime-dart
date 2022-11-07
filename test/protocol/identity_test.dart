import 'package:flutter_test/flutter_test.dart';

import 'package:lime/lime.dart';

void main() {
  group('toString()', () {
    test('should returns name@domain', () {
      final identity1 = Identity(name: 'name', domain: 'domain');

      expect(identity1.toString(), equals('name@domain'));
    });
  });

  group('Identity.parse()', () {
    test('should returns a identity if contains a instance', () {
      final identity = Identity(name: 'name', domain: 'domain');

      expect(Identity.parse('name@domain/abc'), equals(identity));
    });
    test('should returns a identity if not containt a instance', () {
      final identity = Identity(name: 'name', domain: 'domain');

      expect(Identity.parse('name@domain'), equals(identity));
    });
  });

  group('Identity.tryParse()', () {
    test('should returns null', () {
      expect(Identity.tryParse(''), equals(null));
    });
    test('should returns Identity', () {
      final result = Identity.tryParse('name@domain');
      expect(result is Identity, equals(true));
    });
  });

  group('Equals', () {
    test('should returns true with equals properties', () {
      final identity1 = Identity(name: 'name', domain: 'domain');
      final identity2 =
          Identity(name: identity1.name, domain: identity1.domain);

      expect(identity1, equals(identity2));
      expect(identity1.hashCode, equals(identity2.hashCode));
    });
    test('should returns false with different properties', () {
      final identity1 = Identity(name: 'name', domain: 'domain');
      final identity2 = Identity(name: 'name2', domain: identity1.domain);

      expect(identity1, isNot(equals(identity2)));
      expect(identity1.hashCode, isNot(equals(identity2.hashCode)));
    });
  });
}
