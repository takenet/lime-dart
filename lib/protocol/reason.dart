class Reason {
  final int code;
  final String? description;

  Reason({required this.code, this.description});

  @override
  String toString() => '$description (Code $code)';
}
