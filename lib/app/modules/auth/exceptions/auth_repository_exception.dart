class AuthRepositoryException implements Exception {
  final String message;
  final StackTrace? stack;

  AuthRepositoryException(this.message, [this.stack]);
}
