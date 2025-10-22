class Failure implements Exception {
  final String message;
  final String? code;
  Failure(this.message, {this.code});

  @override
  String toString() => code == null ? message : '[$code] $message';
}
