class VersionException implements Exception {
  final String message;

  VersionException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
