import 'package:lime/protocol/node.dart';

class Identity {
  final String name;
  final String domain;

  Identity(this.name, this.domain);

  factory Identity.parse(possibleIdentity) {
    if (possibleIdentity is Node) {
      return possibleIdentity.identity;
    } else if (possibleIdentity is Identity) {
      return possibleIdentity;
    } else if (possibleIdentity is String) {
      var split = possibleIdentity.split('@');
      if (split[0].isNotEmpty && split[1].isNotEmpty) {
        return Identity(split[0], split[1].split('/')[0]);
      }
    }
    return possibleIdentity;
  }

  @override
  String toString() {
    return "$name@$domain";
  }

  @override
  bool operator ==(other) {
    return (other is Identity) && other.name == name && other.domain == domain;
  }

  @override
  int get hashCode => name.hashCode ^ domain.hashCode;
}
