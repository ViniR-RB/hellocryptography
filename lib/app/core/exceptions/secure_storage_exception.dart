class SecureStorageException implements Exception {
  final String message;
  final StackTrace? stack;

  SecureStorageException(this.message, [this.stack]);
}
