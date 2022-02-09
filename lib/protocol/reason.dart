class Reason {
  final int code;
  final String? description;

  Reason({required this.code, this.description});

  @override
  String toString() => '$description (Code $code)';

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(code: json['code'], description: json['description']);
  }
}
