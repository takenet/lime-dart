import 'interfaces/iidentity.dart';

/// Represents an identity in a domain.
class Identity implements IIdentity {
  /// Initializes a new instance of the Identity class.
  Identity({this.name, this.domain});

  @override
  String? domain;

  @override
  String? name;

  @override
  String toString() {
    return domain == null ? name! : "$name@$domain";
  }

  /// Returns a hash code for this instance.
  @override
  int get hashCode => toString().hashCode;

  /// Implements the operator ==
  @override
  bool operator ==(other) => _equals(other);

  /// Parses the string to a valid Identity.
  static Identity parse(String? s) {
    if (s?.isEmpty ?? true) {
      throw ArgumentError.notNull('value');
    }

    final splittedIdentity = s?.split('@');
    final name = splittedIdentity?[0] ?? '';
    final domain = splittedIdentity?[1].split('/')[0] ?? '';

    return Identity(name: name, domain: domain);
  }

  /// Tries to parse the string to a valid Identity.
  static Identity? tryParse(
    String? s,
  ) {
    try {
      return parse(s);
    } catch (e) {
      return null;
    }
  }

  /// Creates a new object that is a copy of the current instance.
  Identity copy() {
    return Identity(name: name, domain: domain);
  }

  bool _equals(other) {
    final identity = other as Identity?;

    if (identity == null) return false;

    return ((name == null && identity.name == null) ||
            (name != null &&
                name?.toLowerCase() == identity.name?.toLowerCase())) &&
        ((domain == null && identity.domain == null) ||
            (domain != null &&
                domain?.toLowerCase() == identity.domain?.toLowerCase()));
  }
}
