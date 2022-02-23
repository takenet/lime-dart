import 'identity.dart';
import 'interfaces/inode.dart';

/// Represents an element of a network.
class Node extends Identity implements INode {
  /// Initializes a new instance of the node class.
  Node({String? name, String? domain, this.instance}) : super(name: name, domain: domain);

  /// The name of the instance used by the node to connect to the network.
  @override
  String? instance;

  /// Returns a hash code for this instance.
  @override
  int get hashCode => toString().hashCode;

  /// Implements the operator ==
  @override
  bool operator ==(other) => _equals(other);

  @override
  String toString() {
    return instance == null ? super.toString() : '${super.toString()}/$instance';
  }

  bool _equals(other) {
    final node = other as Node?;

    if (node == null) return false;

    return ((name == null && node.name == null) || (name != null && name?.toLowerCase() == node.name?.toLowerCase())) &&
        ((domain == null && node.domain == null) ||
            (domain != null && domain?.toLowerCase() == node.domain?.toLowerCase())) &&
        ((instance == null && node.instance == null) ||
            (instance != null && instance?.toLowerCase() == node.instance?.toLowerCase()));
  }

  /// Parses the string to a valid Node.
  static Node parse(String? s) {
    if (s?.isEmpty ?? true) {
      throw ArgumentError.notNull('value');
    }

    Identity identity = Identity.parse(s);
    String identityString = identity.toString();

    return Node(
        name: identity.name,
        domain: identity.domain,
        instance: s!.length > identityString.length ? s.substring(identityString.length + 1) : null);
  }

  /// Tries to parse the string to a valid Node.
  static bool tryParse(
    String s,
  ) {
    try {
      parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Creates an Identity instance based on the Node identity.
  Identity toIdentity() {
    return Identity(name: name, domain: domain);
  }

  /// Indicates if the node is a complete representation,
  bool isComplete() {
    return !['', null].contains(name) && !['', null].contains(domain) && !['', null].contains(instance);
  }
}
