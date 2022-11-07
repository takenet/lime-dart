class InsecureSocketException implements Exception {
  String message;

  InsecureSocketException(this.message);

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
