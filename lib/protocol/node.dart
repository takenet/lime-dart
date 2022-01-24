import 'package:lime/protocol/identity.dart';

class Node {
  final Identity identity;
  final String? instance;

  Node({required this.identity, this.instance});

  Identity toIdentity() {
    return identity;
  }

  factory Node.parse(possibleNode) {
    if (possibleNode is Node) {
      return possibleNode;
    } else {
      var identity = Identity.parse(possibleNode);

      var instance =
          possibleNode.toString().substring(identity.toString().length + 1);

      return Node(identity: identity, instance: instance);
    }
  }

  @override
  String toString() {
    if (instance == null) {
      return identity.toString();
    }

    return "${identity.toString()}/$instance";
  }

  @override
  bool operator ==(other) {
    return (other is Node) &&
        other.instance == instance &&
        other.identity == identity;
  }

  @override
  int get hashCode => instance.hashCode ^ identity.hashCode;
}
