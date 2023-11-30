class DocumentsRepositoryExeption implements Exception {
  final String message;
  final StackTrace? stack;

  DocumentsRepositoryExeption(this.message, [this.stack]);
}
