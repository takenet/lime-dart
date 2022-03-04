/// Represents a known reason for events occurred during the client-server interactions.
class Reason {
  final int code;
  final String? description;

  Reason({required this.code, this.description});

  @override
  String toString() => '$description (Code $code)';

  /// Allows converting a collection of key/value pairs, [Map] to a [Reason] object
  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(code: json['code'], description: json['description']);
  }

  /// Allows converting a [Reason] object to a [Map] collection of key/value pairs
  Map<String, dynamic> toJson() {
    Map<String, dynamic> reason = {
      'code': code,
      'description': description ?? ''
    };

    return reason;
  }
}
