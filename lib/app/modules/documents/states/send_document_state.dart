sealed class SendDocumentState {}

final class SendDocumentInitialState extends SendDocumentState {}

final class SendDocumentLoadignState extends SendDocumentState {}

final class SendDocumentSucessState extends SendDocumentState {}

final class SendDocumentErrorState extends SendDocumentState {
  final String message;
  SendDocumentErrorState(this.message);
}
