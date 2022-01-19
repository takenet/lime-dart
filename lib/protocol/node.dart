import 'package:lime/protocol/identity.dart';

class Node {
  final Identity identity;
  final String? instance;

  Node({required this.identity, this.instance});

  Identity toIdentity() {
    return identity;
  }

  @override
  String toString() {
    if (instance!.isNotEmpty) {
      return identity.toString();
    }

    return "$identity/$instance";
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
}
